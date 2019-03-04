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
    public static let LOGIN_API = AppUtils.BASE_URL + "/auth";
    
    // MARK: - Session Login Requirements
    
    //used as key for storing USER_SESSION_MAP
    public static let KEY_USER_SESSION = "user_session";
    
    //user map on UserDefaults
    public static let USER_EMAIL = "user_email";
    public static let USER_TOKEN = "user_token";
    public static let IS_AUTHENTICATED = "is_authenticated";
    public static let USER_SESSION_MAP: [String: Any?] = [AppUtils.USER_EMAIL : "",
                                                          AppUtils.USER_TOKEN : "",
                                                          AppUtils.IS_AUTHENTICATED: false];
    
    // MARK: - Validate Email
    public static func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
}
