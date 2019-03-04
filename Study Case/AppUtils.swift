//
//  AppUtils.swift
//  Study Case
//
//  Created by Rudi Wijaya on 04/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import Foundation


class AppUtils {
    
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
    
    
}
