//
//  ViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/17/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKLoginKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onFacebookPressed(_ sender: Any) {
        self.loginFacebook()
    }
    
    func loginFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { [unowned self] (result, error) in
            if error != nil {
                print("Process error")
            } else if (result!.isCancelled) {
                print("Cancelled")
            } else {
                print("Process ok")
            }
        }
    }

}

