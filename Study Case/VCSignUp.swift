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
import SwiftyJSON
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
    
    // MARK: - Update View of Key Board
    
    @objc func keyboarWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue;
            let keyboardHeight = keyboardRectangle.height;
            
            print("keyboarWillShow with height: \(keyboardHeight)");
            print("self.viewBottom.frame.height: \(heightViewBottom)");
            
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
    }
    
}
