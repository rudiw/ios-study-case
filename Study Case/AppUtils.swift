//
//  AppUtils.swift
//  Study Case
//
//  Created by Rudi Wijaya on 04/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import Foundation


class AppUtils {
    // MARK: - API Informations
    public static let BASE_URL = "http://172.19.11.20:9090";
    public static let SIGN_IN_API = AppUtils.BASE_URL + "/auth";
    public static let SIGN_UP_API = AppUtils.BASE_URL + "/registration";
    public static let SIGN_UP_SOC_MED_API = AppUtils.BASE_URL + "/auth/user/socialmedialogin";
    public static let FORGOT_PASSWORD_API = AppUtils.BASE_URL + "/forgot_password";
    public static let LIST_CATEGORY_API = AppUtils.BASE_URL + "/category";
    public static let LIST_SUB_CATEGORY_API = AppUtils.BASE_URL + "/subcategory/getbycategory/";
    
    // MARK: - Session Login Requirements
    
    //used as key for storing USER_SESSION_MAP
    public static let KEY_USER_SESSION = "user_session";
    
    //user map on UserDefaults
    public static let USER_EMAIL = "user_email";
    public static let USER_TOKEN = "user_token";
    public static let IS_AUTHENTICATED = "is_authenticated";
    public static let FACEBOOK_USER_ID = "facebook_user_id";
    public static let FACEBOOK_USER_TOKEN = "facebook_user_token";
    public static let GOOGLE_USER_ID = "google_user_id";
    public static let GOOGLE_USER_TOKEN = "google_user_token";
    public static let USER_SESSION_MAP: [String: Any?] = [AppUtils.USER_EMAIL : "",
                                                          AppUtils.USER_TOKEN : "",
                                                          AppUtils.IS_AUTHENTICATED: false,
                                                          AppUtils.FACEBOOK_USER_ID: "",
                                                          AppUtils.FACEBOOK_USER_TOKEN: "",
                                                          AppUtils.GOOGLE_USER_ID: "",
                                                          AppUtils.GOOGLE_USER_TOKEN: ""];
    
//    client id google one click study case
    public static let GOOGLE_CLIENT_ID = "1070994837926-ldftgse09qsii0iuc53goh6du74qebnc.apps.googleusercontent.com";
    
    //twitter keys
//    public static let TWITTER_API_KEY = "CrRnLN16r8PAMUD451ltJoQcn"
//    public static let TWITTER_API_SECRET_KEY = "rsB9Ve1wguOpBWuAERJD8H5kntcxTgrB4l6TyGeHL8UW1vzfJ7"
    public static let TWITTER_API_KEY = "u44cvz6f6fiapQoZ1BkZatzan"
    public static let TWITTER_API_SECRET_KEY = "yLhvEWkEhZTTGbI6CZ8s5eRNq8ILmmUsgClutQ2k7GiI5r4yS3"
    
    // MARK: - Validate Email
    public static func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    public static func getUserToken() -> String {
        let userSessionMap = UserDefaults.standard.value(forKey: AppUtils.KEY_USER_SESSION) as! [String: Any]
        let userToken = userSessionMap[AppUtils.USER_TOKEN] as! String;
        return userToken;
    }
    
}
