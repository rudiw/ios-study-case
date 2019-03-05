//
//  VCSignUp.swift
//  Study Case
//
//  Created by Rudi Wijaya on 05/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import ChameleonFramework


class VCSignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var heightViewTop: NSLayoutConstraint!
    
    var colorBg: UIColor = UIColor.randomFlat;
    
    var heightViewBottom: CGFloat = 0.0;
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        print("VCSignUp | view did load");
        
        self.title = "Sign Up";
        
        self.view.backgroundColor = colorBg;
        self.viewTop.backgroundColor = colorBg;
        self.viewBottom.backgroundColor = colorBg;
        self.btnSignUp.backgroundColor = ContrastColorOf(colorBg, returnFlat: true);
        self.btnSignUp.setTitleColor(ContrastColorOf(self.btnSignUp.backgroundColor!, returnFlat: true), for: .normal);
        
        txtName.delegate = self;
        txtEmail.delegate = self;
        txtPassword.delegate = self;
        
        let tapOnViewTop = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard));
        viewTop.addGestureRecognizer(tapOnViewTop);
        let tapOnImgLogo = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard));
        imgLogo.addGestureRecognizer(tapOnImgLogo);
        let tapOnViewBottom = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard));
        viewBottom.addGestureRecognizer(tapOnViewBottom);
        
        heightViewBottom = self.viewBottom.frame.height;
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
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
    
    // MARK: - Update View of Keyboard
    
    @objc func keyboarWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue;
            let keyboardHeight = keyboardRectangle.height;
            
//            print("keyboarWillShow with height: \(keyboardHeight)");
//            print("self.viewBottom.frame.height: \(heightViewBottom)");
            
            self.heightViewTop.constant = -1 * (keyboardHeight + (keyboardHeight / 3));
            self.view.layoutIfNeeded();
        }
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.2) {
            self.heightViewTop.constant = 0;
            self.view.layoutIfNeeded();
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideKeyboard();
    }
    
    // MARK: - Do Sign Up
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        let name = txtName.text;
        if (name == nil || name == "") {
            let alert = UIAlertController(title: "Error", message: "Name must not be empty.", preferredStyle: .alert);
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
            alert.addAction(action);
            self.present(alert, animated: true, completion: nil);
            return;
        }
        
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
        
        // input values are valid, ready to send to the api sign up
        hideKeyboard();
        
        let nameArray = name!.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        let firstName = nameArray[0];
        var lastName = nameArray[0];
        if (nameArray.count > 1) {
            lastName = nameArray[1];
        }
        
        let params: Parameters = [
            "email": email!,
            "firtsname": firstName,
            "lastname": lastName,
            "password": password!
        ]
        print("Params to sign in: \(params)");
        
        SVProgressHUD.show();
        Alamofire.request(AppUtils.SIGN_UP_API, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            response in
            
            //            print("Response result value: \(response.result.value)");
            SVProgressHUD.dismiss();
            
            if (response.result.isSuccess && response.response?.statusCode == 201) {
                print("Sign up successfully...");
                
//                let infoLogin: JSON = JSON(response.result.value!);
                
                var userSessionMap = AppUtils.USER_SESSION_MAP;
                userSessionMap[AppUtils.IS_AUTHENTICATED] = true;
                userSessionMap[AppUtils.USER_EMAIL] = email;
                
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
