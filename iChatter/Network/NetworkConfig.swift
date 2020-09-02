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
    
    static var API_URL : String = "https://financialmodelingprep.com/api"

    static var API_VERSION = "v3"
    
    static var API_KEY : String = "b60cdf1ecaaf183fae39abda727dc667"
    
}
