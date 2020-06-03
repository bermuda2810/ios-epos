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
    private var presenter : LoginPresenter!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LoginPresenter(view : self)
    }
    
    //MARK: - SNS Press
    @IBAction func onFacebookPressed(_ sender: Any) {
        presenter.requestLoginFacebook()
    }
    
    @IBAction func onGooglePressed(_ sender: Any) {
        presenter.requestLoginGooogle()
    }
    
    @IBAction func onApplePressed(_ sender: Any) {
        presenter.requestLoginApple()
    }
    
    func gotoChatView() {
        
    }
    
    //MARK: - Error Dialog
    private func showErrorDialog(message : String) {
        print(message)
    }
    
    
    //MARK: - Dialog Waiting
    private func showWaitingDialog() {
        
    }
    
    private func hideWaitingDialog() {
        
    }
}

extension LoginViewController : LoginView {

    func onLoginSuccess() {
        self.hideWaitingDialog()
        self.gotoChatView()
    }
    
    func onLoginFail(message: String) {
        self.showErrorDialog(message: message)
    }
    
    func onStartLogin() {
        self.showWaitingDialog()
    }
}
