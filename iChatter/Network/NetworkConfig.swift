//
//  NetworkConfig.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 7/27/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class NetworkConfig {
    
    static let PRODUCTION = "production"
    static let STAGING = "staging"
    static let DEVELOPMENT = "development"
    
    static let ENV : String = DEVELOPMENT
    
    static var API_URL : String = "https://api-test-branch.schoolbus.cf/api/"
    
    static var API_VERSION = "v1"
//    static var DOMAIN : String = ""
//    static var TOKEN_TYPE : String = ""
    static var ACCESS_TOKEN : String = ""
    static var AUTHORIZATION : String = ""
    
//    static var CLIENT_ID : String = "10"
//    static var CLIENT_SECRET : String = "NUivZBe8znfXecrB0y1YzmC3CTIVtL6MoqjvfMev"
    
    
//    private static func getSettingByKey(_ key : String, _ defaultValue : String) -> String {
//        let value = UserDefaults.standard.string(forKey: key)
//        guard value != nil else {
//            return defaultValue
//        }
//        return value!
//    }
    
}
