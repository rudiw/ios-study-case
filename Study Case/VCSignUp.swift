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


class VCSignUp: UIViewController {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    
    var colorBg: UIColor = UIColor.randomFlat;
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        print("VCSignUp | view did load");
        
        self.view.backgroundColor = colorBg;
        self.viewTop.backgroundColor = colorBg;
        self.viewBottom.backgroundColor = colorBg;
        self.btnSignUp.backgroundColor = ContrastColorOf(colorBg, returnFlat: true);
        self.btnSignUp.setTitleColor(ContrastColorOf(self.btnSignUp.backgroundColor!, returnFlat: true), for: .normal);
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
    
    // MARK: - Do Sign Up
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        print("Do sign up...");
    }
    
}
