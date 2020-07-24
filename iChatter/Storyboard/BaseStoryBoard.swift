//
//  StoryboardHelper.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/28/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import Foundation
import UIKit

class BaseStoryBoard {
    
    public func getInitialViewController() -> UIViewController {
        let storyboardName = self.storyBoardName()
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()!
    }
    
    public func getControllerByStoryboardID(identifier : String) -> UIViewController {
        let storyboardName = self.storyBoardName()
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func storyBoardName() -> String {
        return ""
    }
}
