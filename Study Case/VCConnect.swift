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


class VCConnect: UIViewController {
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
    }
    
    @IBAction func btnGooglePressed(_ sender: UIButton) {
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
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,first_name,last_name"], tokenString: token, version: nil, httpMethod: "GET")
            req?.start(completionHandler: { (connection, result, error) in
                if (error != nil) {
                    print("Failed to get user profile: \(error)");
                } else {
                    print("Got profile user: \(result)");
                    let infoUser = result as! [String: Any];
                    self.registerUser(email: infoUser["email"] as! String, firstName: infoUser["first_name"]  as! String, lastName: infoUser["last_name"] as! String, fbUserId: infoUser["id"]  as! String, fbUserToken: token);
                }
            })
        }
    }
    
    // MARK: - Register User to Server
    
    func registerUser(email: String, firstName: String, lastName: String, fbUserId: String, fbUserToken: String) {
        let params: Parameters = [
            "email": email,
            "firtsname": firstName,
            "lastname": lastName
        ]
        print("Params to sign in: \(params)");

        SVProgressHUD.show();
        Alamofire.request(AppUtils.SIGN_UP_API, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            response in

            SVProgressHUD.dismiss();

            if (response.result.isSuccess && response.response?.statusCode == 201) {
                print("Sign up successfully...");

                var userSessionMap = AppUtils.USER_SESSION_MAP;
                userSessionMap[AppUtils.IS_AUTHENTICATED] = true;
                userSessionMap[AppUtils.USER_EMAIL] = email;
                userSessionMap[AppUtils.FACEBOOK_USER_ID] = fbUserId;
                userSessionMap[AppUtils.FACEBOOK_USER_TOKEN] = fbUserToken;

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
