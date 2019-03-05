//
//  VCForgotPassword.swift
//  Study Case
//
//  Created by Rudi Wijaya on 05/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import ChameleonFramework


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
    }
    
}
