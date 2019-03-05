//
//  VCLogin.swift
//  Study Case
//
//  Created by Rudi Wijaya on 04/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import ChameleonFramework


class VCSignIn: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewRegister: UIView!
    
    @IBOutlet weak var heightViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var lblSignUp: UILabel!
    
    var colorBg: UIColor = UIColor.randomFlat;
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        print("VCSignIn | view did load");
        
        colorBg = UIColor.randomFlat
        self.view.backgroundColor = colorBg;
        self.viewTop.backgroundColor = colorBg;
        self.viewLogin.backgroundColor = colorBg;
        self.viewRegister.backgroundColor = colorBg;
        self.btnSignIn.backgroundColor = ContrastColorOf(colorBg, returnFlat: true);
        self.btnSignIn.setTitleColor(ContrastColorOf(self.btnSignIn.backgroundColor!, returnFlat: true), for: .normal);
        self.lblSignUp.textColor = ContrastColorOf(colorBg, returnFlat: true);
        
        txtEmail.delegate = self;
        txtPassword.delegate = self;
        
        let tapOnViewTop = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard));
        viewTop.addGestureRecognizer(tapOnViewTop);
        let tapOnImgLogo = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard));
        imgLogo.addGestureRecognizer(tapOnImgLogo);
        let tapOnViewBottom = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard));
        viewBottom.addGestureRecognizer(tapOnViewBottom);
        
        let tapOnLblSignUp = UITapGestureRecognizer(target: self, action: #selector(showSignUp));
        lblSignUp.isUserInteractionEnabled = true;
        lblSignUp.addGestureRecognizer(tapOnLblSignUp);
        
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
    
    // MARK: - Update View of Key Board
    @objc func hideKeyBoard() {
//        print("hide key board");
        UIView.animate(withDuration: 0.2) {
            self.heightViewTop.constant = 0;
            self.view.layoutIfNeeded();
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("did begin editing");
        UIView.animate(withDuration: 0.2) {
            self.heightViewTop.constant = -310
            self.view.layoutIfNeeded();
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("did end editing");
        hideKeyBoard()
    }
    
    // MARK: - Do Sign In
    
    @IBAction func btnSignInPressed(_ sender: UIButton) {
        let email = txtEmail.text;
        if (email == nil || email == "") {
            let alert = UIAlertController(title: "Error", message: "Email must not be empty.", preferredStyle: .alert);
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
            alert.addAction(action);
            self.present(alert, animated: true, completion: nil);
            return;
        }
        if (!AppUtils.validateEmail(candidate: email!)) {
            let alert = UIAlertController(title: "Error", message: "Email is not valid.", preferredStyle: .alert);
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
            alert.addAction(action);
            self.present(alert, animated: true, completion: nil);
            return;
        }
        
        let password = txtPassword.text;
        if (password == nil || password == "") {
            let alert = UIAlertController(title: "Error", message: "Password must not be empty.", preferredStyle: .alert);
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
            alert.addAction(action);
            self.present(alert, animated: true, completion: nil);
            return;
        }
        
        // email and password are valid, ready to send to the api login
        hideKeyBoard();
        
        let params: Parameters = [
            "email": email!,
            "password": password!
        ]
//        print("Params to sign in: \(params)");

        SVProgressHUD.show();
        Alamofire.request(AppUtils.LOGIN_API, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            response in
            
//            print("Response result value: \(response.result.value)");
            SVProgressHUD.dismiss();
            
            if (response.result.isSuccess && response.response?.statusCode == 200) {
                print("Sign in successfully...");

                let infoLogin: JSON = JSON(response.result.value!);
                
                var userSessionMap = AppUtils.USER_SESSION_MAP;
                userSessionMap[AppUtils.IS_AUTHENTICATED] = true;
                let email = infoLogin["data"]["user"]["email"].stringValue;
                userSessionMap[AppUtils.USER_EMAIL] = email;
                let token = infoLogin["data"]["token"].stringValue
                userSessionMap[AppUtils.USER_TOKEN] = token;
                
                print("userSessionMap: \(userSessionMap)");
                
                UserDefaults.standard.set(userSessionMap, forKey: AppUtils.KEY_USER_SESSION)
                
                let app = UIApplication.shared.delegate as? AppDelegate;
                app?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController();
                
            } else if (response.result.isSuccess && response.response?.statusCode == 401) {
                print("Invalid credentials: \(response.result.error)");
                
                let alert = UIAlertController(title: "Error", message: "Invalid credentials.", preferredStyle: .alert);
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
                alert.addAction(action);
                self.present(alert, animated: true, completion: nil);
            } else {
                print("Failed to sign in: \(response.result.error)");
                
                let alert = UIAlertController(title: "Error", message: "Please try again latter.", preferredStyle: .alert);
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
                alert.addAction(action);
                self.present(alert, animated: true, completion: nil);
            }
        })
    }
    
    
    // MARK: - Show Sign Up Form
    @objc func showSignUp() {
        print("Perform seque to sign up...");
        performSegue(withIdentifier: "toVcSignUp", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vcSignUp = segue.destination as! VCSignUp;
        vcSignUp.colorBg = colorBg;
    }
    
}
