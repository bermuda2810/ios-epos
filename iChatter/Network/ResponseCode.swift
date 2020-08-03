//
//  ResponseCode.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 7/27/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit


class ResponseCode {
    static let success : Int = 200
    static let timeout : Int = -1001
    static let wrongResponseFormat : Int = 9999
    static let urlNotSupport : Int = -1002
    static let noConnection : Int = -1009
    static let errorAuth : Int = 401
    static let serverError : Int = 500
    static let parseJSONError : Int = 2000
    static let invalidEmail : Int = 2001
    static let invalidPassword : Int = 2002
    
    static func getMessageByCode(_ code : Int) -> String {
        return NSLocalizedString("\(code)", tableName: "LocalizationMessage", comment: "")
    }
}
