//
//  AppDelegate.swift
//  Study Case
//
//  Created by Rudi Wijaya on 25/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //facebook
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions);
        
        //google
        GIDSignIn.sharedInstance().clientID = AppUtils.GOOGLE_CLIENT_ID;
        
        //twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey: AppUtils.TWITTER_API_KEY, consumerSecret: AppUtils.TWITTER_API_SECRET_KEY)
        
        //check loggedIn in session
        if let _ = UserDefaults.standard.value(forKey: AppUtils.KEY_USER_SESSION) {
            //user is authenticated
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController();
        } else {
            //user is not authenticated
            let vcLogin = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "vcConnect");
            self.window?.rootViewController = UINavigationController(rootViewController: vcLogin);
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //facebook
        let handledFacebook = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options);
        //google
        let handledGoogle = GIDSignIn.sharedInstance()?.handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]);
        
        //twitter
        let handledTwitter = TWTRTwitter.sharedInstance().application(app, open: url, options: options);
        
        return handledFacebook! && handledGoogle! && handledTwitter;
    }

}

