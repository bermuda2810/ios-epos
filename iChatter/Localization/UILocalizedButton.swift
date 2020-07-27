//
//  UILocalizedButton.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 7/27/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

@IBDesignable class UILocalizedButton: UIButton {
    
    @IBInspectable var screenName: String? {
        didSet {
            guard let tableName = screenName else { return }
            let title = self.title(for: .normal)?.localized(tableName: tableName)
            setTitle(title, for: .normal)
        }
    }
}
