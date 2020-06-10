//
//  ViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/17/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import CoreLocation

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var loginStackView: UIStackView!
    private var presenter : LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = LoginPresenter(view : self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - SNS Login
    @IBAction func onFacebookPressed(_ sender: Any) {
        presenter.requestLoginFacebook()
    }
    
    @IBAction func onGooglePressed(_ sender: Any) {
        presenter.requestLoginGooogle()
    }
    
    @IBAction func onApplePressed(_ sender: Any) {
        presenter.requestLoginApple()
    }

    @IBAction func onRegisterPressed(_ sender: Any) {
//        performSegue(withIdentifier: "segueShowRegisterScreen", sender: nil)
        let registerVC = MainStoryBoard.init().getViewControllerByIdentifier(identifier: "RegisterViewController")
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    //MARK: - Error Dialog
    private func showErrorDialog(message : String) {
        print(message)
    }
    
}

extension LoginViewController : LoginView {

    func onLoginSuccess() {
        self.hideWaitingDialog()
        self.gotoChatView()
    }
    
    func onLoginFail(message: String) {
        self.hideWaitingDialog()
        self.showErrorDialog(message: message)
    }
    
    func onStartLogin() {
        self.showWaitingDialog()
    }
    
    func gotoChatView() {
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        sceneDelegate.setupRootViewController()
    }
}
