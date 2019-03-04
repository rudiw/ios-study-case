//
//  VCLogin.swift
//  Study Case
//
//  Created by Rudi Wijaya on 04/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit


class VCLogin: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var heightViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        print("view did load");
        
        txtEmail.delegate = self;
        txtPassword.delegate = self;
        
        let tapOnViewTop = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard));
        viewTop.addGestureRecognizer(tapOnViewTop);
        let tapOnImgLogo = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard));
        imgLogo.addGestureRecognizer(tapOnImgLogo);
        let tapOnViewBottom = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard));
        viewBottom.addGestureRecognizer(tapOnViewBottom);
        
    }
    
    // MARK: Update View of Key Board
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
    
    
    
}
