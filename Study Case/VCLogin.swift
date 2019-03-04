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


class VCLogin: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var heightViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK: - View Did Load
    
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
        
//        let parameters: Parameters = [
//            "foo": [1,2,3],
//            "bar": [
//                "baz": "qux"
//            ]
//        ]
//
//        SVProgressHUD.show();
//        Alamofire.request(AppUtils.LOGIN_API, method: .post, parameters: params).responseJSON(completionHandler: {
//            response in
//            if (response.result.isSuccess) {
//                print("Got weather data successfully...");
//
//                let weatherJson: JSON = JSON(response.result.value!);
//                //                print("Got weather data: \(weatherJson)");
//                self.setWeather(upData: weatherJson);
//            } else {
//                print("Can not get weather: \(response.result.error)");
//                self.cityLabel.text = "Connection Issues";
//            }
//        })
    }
    
    
}
