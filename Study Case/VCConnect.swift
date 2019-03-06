//
//  VCConnect.swift
//  Study Case
//
//  Created by Rudi Wijaya on 06/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import ChameleonFramework


class VCConnect: UIViewController {
    @IBOutlet weak var viewTop: UIView!
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
        self.lblSignUp.textColor = ContrastColorOf(colorBg, returnFlat: true);
        
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
    
    // MARK: - Show Sign Up Form
    @objc func showSignUp() {
        print("Perform seque to sign up...");
        performSegue(withIdentifier: "vcConnectToVcSignIn", sender: self);
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /**
         it can be used class parent for colorBg
         */
        if (segue.destination is VCSignIn) {
            let toVc = segue.destination as! VCSignIn;
            toVc.colorBg = colorBg;
        }
        
    }
}
