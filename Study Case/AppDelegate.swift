//
//  AppDelegate.swift
//  Study Case
//
//  Created by Rudi Wijaya on 25/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions);
        
        
        if let _ = UserDefaults.standard.value(forKey: AppUtils.KEY_USER_SESSION) {
            //user is authenticated
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController();
        } else {
            //user is not authenticated
            let vcLogin = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "vcLogin");
            self.window?.rootViewController = UINavigationController(rootViewController: vcLogin);
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options);
        return handled!;
    }


}

