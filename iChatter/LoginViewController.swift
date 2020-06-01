//
//  ViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/17/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import CoreLocation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginStackView: UIStackView!
    
    private var loginPresenter : LoginPresenter!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter = LoginPresenter()
    }
    

    @IBAction func onFacebookPressed(_ sender: Any) {
        loginPresenter.loginFacebook(viewController: self)
    }
    
    @IBAction func onGooglePressed(_ sender: Any) {
        loginPresenter.loginGoogle(viewController: self)
    }
    
    @IBAction func onApplePressed(_ sender: Any) {
        loginPresenter.loginApple(window: self.view.window!)
    }

}

