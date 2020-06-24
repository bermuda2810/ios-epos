//
//  DateExtension.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/22/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
