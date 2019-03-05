//
//  VCForgotPassword.swift
//  Study Case
//
//  Created by Rudi Wijaya on 05/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import ChameleonFramework
import Alamofire
import SVProgressHUD


class VCForgotPassword: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    var colorBg: UIColor = UIColor.randomFlat;
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        print("VCForgotPassword - view did load");
        
        self.title = "Forgot Password";
        
        self.view.backgroundColor = colorBg;
        self.btnSubmit.backgroundColor = ContrastColorOf(colorBg, returnFlat: true);
        self.btnSubmit.setTitleColor(ContrastColorOf(self.btnSubmit.backgroundColor!, returnFlat: true), for: .normal);
        
        txtEmail.delegate = self;
        
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
//            let keyboardRectangle = keyboardFrame.cgRectValue;
//            let keyboardHeight = keyboardRectangle.height;
            self.centerY.constant = -100;
            self.view.layoutIfNeeded();
        }
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.2) {
            self.centerY.constant = 0;
            self.view.layoutIfNeeded();
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideKeyboard();
    }
    
    // MARK: - Do Submit Email
    
    @IBAction func btnSubmitPressed(_ sender: UIButton) {
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
        
        // input values are valid, ready to send to the api sign up
        hideKeyboard();
        
        let params: Parameters = [
            "email": email!
        ]
        print("Params to sign in: \(params)");
        
        SVProgressHUD.show();
        Alamofire.request(AppUtils.FORGOT_PASSWORD_API, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            response in
            
            //            print("Response result value: \(response.result.value)");
            SVProgressHUD.dismiss();
            
            if (response.result.isSuccess && response.response?.statusCode == 200) {
                print("Submit forgot password successfully...");
                
                let alert = UIAlertController(title: "Info", message: "Please check your email to continue.", preferredStyle: .alert);
                let action = UIAlertAction(title: "Ok", style: .default){ (action) in
                    let _ = self.navigationController?.popViewController(animated: true);
                };
                alert.addAction(action);
                self.present(alert, animated: true, completion: nil);
            } else {
                print("Failed to sign up: \(response.result)");
                
                let alert = UIAlertController(title: "Error", message: "Please try again later.", preferredStyle: .alert);
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
                alert.addAction(action);
                self.present(alert, animated: true, completion: nil);
            }
        })
    }
    
}
