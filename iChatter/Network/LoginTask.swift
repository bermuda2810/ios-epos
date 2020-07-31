//
//  LoginTask.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 7/29/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginTask: BaseTask<TokenItem>, TaskDatasource {
    
    private var username : String!
    private var password : String!
    
    init(username : String!, password : String!) {
        self.username = username
        self.password = password
    }
    
    func method() -> HTTPMethod {
        return HTTPMethod.post
    }
    
    func api() -> String {
        return Api.login
    }
    
    func parameters() -> Parameters? {
        return ["username": username!,
                "password": password!]
    }
    
    func onParseDataByResponse(_ response: JSON) throws -> Any {
        let accessToken = response["data"]["token"].stringValue
        var token = TokenItem()
        token.accessToken = accessToken
        return token
    }
    
    func paramEncoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}
