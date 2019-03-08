//
//  VCConnect.swift
//  Study Case
//
//  Created by Rudi Wijaya on 06/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import ChameleonFramework
import FBSDKCoreKit
import FBSDKLoginKit
import SVProgressHUD
import Alamofire
import GoogleSignIn
import SwiftyJSON
import TwitterKit


class VCConnect: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var sViewConnect: UIStackView!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblSignUp: UILabel!
    
    var colorBg: UIColor = UIColor.randomFlat;
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        print("VCConnect - view did load");
        
        colorBg = UIColor.randomFlat
        self.view.backgroundColor = colorBg;
        self.viewTop.backgroundColor = colorBg;
        self.viewBottom.backgroundColor = colorBg;
        
        self.btnSignIn.backgroundColor = ContrastColorOf(colorBg, returnFlat: true);
        self.btnSignIn.setTitleColor(ContrastColorOf(self.btnSignIn.backgroundColor!, returnFlat: true), for: .normal);
        
        self.btnFacebook.backgroundColor = ContrastColorOf(colorBg, returnFlat: true);
        self.btnFacebook.setTitleColor(ContrastColorOf(self.btnFacebook.backgroundColor!, returnFlat: true), for: .normal);
        
        self.btnTwitter.backgroundColor = ContrastColorOf(colorBg, returnFlat: true);
        self.btnTwitter.setTitleColor(ContrastColorOf(self.btnTwitter.backgroundColor!, returnFlat: true), for: .normal);
        
        self.btnGoogle.backgroundColor = ContrastColorOf(colorBg, returnFlat: true);
        self.btnGoogle.setTitleColor(ContrastColorOf(self.btnGoogle.backgroundColor!, returnFlat: true), for: .normal);
        self.lblSignUp.textColor = ContrastColorOf(colorBg, returnFlat: true);
        
        let tapOnLblSignUp = UITapGestureRecognizer(target: self, action: #selector(showSignUp));
        lblSignUp.isUserInteractionEnabled = true;
        lblSignUp.addGestureRecognizer(tapOnLblSignUp);
        
        //google
        GIDSignIn.sharedInstance().delegate = self;
        GIDSignIn.sharedInstance().uiDelegate = self;
        
//        FB Check Current Login Status
        if (FBSDKAccessToken.currentAccessTokenIsActive()) {
            // User is logged in, do work such as go to next view controller.
            print("User fb is logged in...");
        }
        
//        FB Ask for Permissions
        
        // Extend the code sample from 6a. Add Facebook Login to Your Code
        // Add to your viewDidLoad method:
//        loginButton.readPermissions = @[@"public_profile", @"email"];
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar();
    }
    
    func updateNavBar() {
        guard let navbar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist");
        }
        
        navbar.barTintColor = colorBg;
        navbar.tintColor = ContrastColorOf(colorBg, returnFlat: true);
        navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(colorBg, returnFlat: true) ]
    }
    
    // MARK: - Button Pressed
    
    @IBAction func btnSignInPressed(_ sender: UIButton) {
        print("Perform seque to sign in...");
        performSegue(withIdentifier: "vcConnectToVcSignIn", sender: self);
    }
    
    @IBAction func btnFacebookPressed(_ sender: UIButton) {
        let fbLoginMgr = FBSDKLoginManager.init();
        fbLoginMgr.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
//            print("Login using facebook got result: \(result)");
//            print("Login using facebook got error: \(error)");
            if (error != nil) {
                print("Failed to login using facebook: \(error)");
            } else if (result?.isCancelled ?? false) {
                print("User canceled login using facebook...");
            } else {
                print("User has logged in using facebook...");
                self.loadFacebookProfile(token: result!.token.tokenString);
            }
        }
    }

    @IBAction func btnTwitterPressed(_ sender: UIButton) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as userName \(session!.userName)");
                print("signed in as userID \(session!.userID)");
                print("signed in as authToken \(session!.authToken)");
                print("signed in as authTokenSecret \(session!.authTokenSecret)");
                
                let client = TWTRAPIClient.withCurrentUser()
                client.loadUser(withID: session!.userID, completion: { (user, error) in
                    if (error != nil) {
                        print("Request user failed with error: \(error!.localizedDescription)");
                    } else {
                        let upName = user!.name
                        
                        client.requestEmail { email, error in
                            if (email != nil) {
                                print("signed in as \(email)");
                                
                                let nameArray = upName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
                                let upFirstName = nameArray[0];
                                var upLastName = nameArray[0];
                                if (nameArray.count > 1) {
                                    upLastName = nameArray[1];
                                }
                                
                                self.registerUser(user: User(id: session!.userID, email: email!, fullName: upName, firstName: String(upFirstName), lastName: String(upLastName), token: session!.authToken, type: .TWITTER))
                            } else {
                                print("Request email failed with error: \(error!.localizedDescription)");
                            }
                        }
                    }
                })

            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
    }
    
    @IBAction func btnGooglePressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn();
    }
    
    // MARK: - Show Sign Up Form
    @objc func showSignUp() {
        print("Perform seque to sign up...");
        performSegue(withIdentifier: "vcConnectToVcSignUp", sender: self);
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /**
         it can be used class parent for colorBg
         */
        if (segue.destination is VCSignUp) {
            let toVc = segue.destination as! VCSignUp;
            toVc.colorBg = colorBg;
        }
        if (segue.destination is VCSignIn) {
            let toVc = segue.destination as! VCSignIn;
            toVc.colorBg = colorBg;
        }
        
    }
    
    // MARK: - Facebook Load Profile
    func loadFacebookProfile(token: String) {
        if (FBSDKAccessToken.currentAccessTokenIsActive()) {
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, first_name, last_name"], tokenString: token, version: nil, httpMethod: "GET")
            req?.start(completionHandler: { (connection, result, error) in
                if (error != nil) {
                    print("Failed to get user profile: \(error)");
                } else {
                    print("Got profile user: \(result)");
                    let infoUser = result as! [String: Any];
                    let fbUser = User(id: infoUser["id"]  as! String, email: infoUser["email"] as! String, fullName: infoUser["name"]  as! String, firstName: infoUser["first_name"]  as! String, lastName: infoUser["last_name"] as! String, token: token, type: UserType.FACEBOOK);
                    self.registerUser(user: fbUser);
                }
            })
        }
    }
    
    // MARK: - Google Sign In Performs
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("Google sign in will dispatch..");
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("Present googe sign in");
        self.present(viewController, animated: true, completion: nil);
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("Dismiss googe sign in");
        self.dismiss(animated: true, completion: nil);
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("Failed to signn in using google: \(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID!                 // For client-side use only!
            print("Got google user id: \(userId)");
            let idToken = user.authentication.idToken! // Safe to send to the server
            print("Got google user idToken: \(idToken)");
            let fullName = user.profile.name!
            print("Got google user fullName: \(fullName)");
            let givenName = user.profile.givenName!
            print("Got google user givenName: \(givenName)");
            let familyName = user.profile.familyName!
            print("Got google user familyName: \(familyName)");
            let email = user.profile.email!
            print("Got google user email: \(email)");
            let gUser = User(id: userId, email: email, fullName: fullName, firstName: givenName, lastName: familyName, token: idToken, type: .GOOGLE);
            self.registerUser(user: gUser);
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // MARK: - Register User to Server
    func registerUser(user: User) {
        let params: Parameters = [
            "email": user.email,
            "firtsname": user.firstName,
            "lastname": user.lastName,
            "role_id": 3,
            "origin": user.type.rawValue
        ]
        print("Params to sign in: \(params)");

        SVProgressHUD.show();
        Alamofire.request(AppUtils.SIGN_UP_SOC_MED_API, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            response in
            
//            print("Response result value: \(response.result.value)");

            SVProgressHUD.dismiss();

            if (response.result.isSuccess && response.response?.statusCode == 200) {
                print("Connect using '\(user.type)' successfully...");
                
                let infoLogin: JSON = JSON(response.result.value!);

                var userSessionMap = AppUtils.USER_SESSION_MAP;
                userSessionMap[AppUtils.IS_AUTHENTICATED] = true;
                userSessionMap[AppUtils.USER_EMAIL] = user.email;
                userSessionMap[AppUtils.USER_TOKEN] = infoLogin["data"]["token"].stringValue;
                if (user.type == UserType.FACEBOOK) {
                    userSessionMap[AppUtils.FACEBOOK_USER_ID] = user.id;
                    userSessionMap[AppUtils.FACEBOOK_USER_TOKEN] = user.token;
                }
                if (user.type == UserType.GOOGLE) {
                    userSessionMap[AppUtils.GOOGLE_USER_ID] = user.id;
                    userSessionMap[AppUtils.GOOGLE_USER_TOKEN] = user.token;
                }

                print("userSessionMap: \(userSessionMap)");

                UserDefaults.standard.set(userSessionMap, forKey: AppUtils.KEY_USER_SESSION)

                let app = UIApplication.shared.delegate as? AppDelegate;
                app?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController();

            } else {
                print("Failed to sign up: \(response.result)");

                let alert = UIAlertController(title: "Error", message: "Please try again later.", preferredStyle: .alert);
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
                alert.addAction(action);
                self.present(alert, animated: true, completion: nil);
            }
        });
    }
}
