//
//  LanguageItem.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 7/27/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class LanguageItem: NSObject {
    public var index : Int!
    public var title : String!
    public var state : Bool!
    public var value : String!
    
    init(_ index : Int, _ title : String, _ state : Bool = false, _ value : String = "en-US") {
        self.index = index
        self.title = title
        self.state = state
        self.value = value
    }
}
