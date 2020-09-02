//
//  ExtensionString.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 9/1/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

extension Date {
    func formatDate(format : String) -> String {
            let formatter = DateFormatter(format: format)
            let result = formatter.string(from: self)
            return result
    }
}

extension String {
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
}
