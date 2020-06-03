//
//  LoginPresenter.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 5/29/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import Firebase


protocol LoginView {
    func onLoginSuccess()
    func onLoginFail(message : String)
    func onStartLogin()
}

class LoginPresenter : NSObject {
    
    weak var window : UIWindow!
    var loginView : LoginView?
    
    init(view : LoginView) {
        self.loginView = view
    }
    
    //MARK: - Request Login
    func requestLoginFacebook() {
        if loginView == nil {
            return
        }
        let loginManager = LoginManager()
        let vc = loginView as? UIViewController
        loginManager.logIn(permissions: ["public_profile"], from: vc) { [unowned self] (result, error) in
            self.handleLoginFacebook(result, error)
        }
    }
    
    func requestLoginGooogle() {
        let vc = loginView as? UIViewController
        GIDSignIn.sharedInstance().clientID = "960357596349-4de4qg75oh8jbl98679rmshhpnqksmpb.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = vc
        GIDSignIn.sharedInstance().signIn()
    }
    
    func requestLoginApple() {
        let vc = loginView as? UIViewController
        self.window = vc?.view.window
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - Handle after login by Facebook
    private func handleLoginFacebook(_ result : LoginManagerLoginResult?, _ error : Error?) {
        if error != nil {
            self.loginView?.onLoginFail(message: "Login FB Error")
        } else if (result!.isCancelled) {
            self.loginView?.onLoginFail(message: "User FB cancel")
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            self.authWithFirebase(credential: credential)
        }
    }
    
    // MARK: - Authen by Firebase
    private func authWithFirebase(credential : AuthCredential) {
        loginView?.onStartLogin()
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                self.loginView?.onLoginFail(message: error.debugDescription)
            }else {
                self.loginView?.onLoginSuccess()
            }
        }
    }
}

// MARK: - Google Login
extension LoginPresenter : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            handleErrorLoginGoogle(error)
        }else {
            handleGoogleSuccess(user)
        }
    }
    
    private func handleErrorLoginGoogle(_ error: Error!) {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
        } else {
            print("\(error.localizedDescription)")
        }
        loginView?.onLoginFail(message: "Login Google error")
    }
    
    private func handleGoogleSuccess(_ user: GIDGoogleUser!) {
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        self.authWithFirebase(credential: credential)
    }
}

// MARK: - Apple Login
extension LoginPresenter : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window
    }
}
