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

class LoginPresenter: NSObject, GIDSignInDelegate , ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    weak var window : UIWindow!
    
        
    func loginFacebook(viewController : LoginViewController)  {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: viewController) { [unowned self] (result, error) in
            if error != nil {
                print("Process error")
            } else if (result!.isCancelled) {
                print("Cancelled")
            } else {
                print("Process ok")
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                self.authWithFirebase(credential: credential)
//                self.requestFacebookProfile()
            }
        }
    }
    
    
    private func authWithFirebase(credential : AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            print("Auth ok")
        }
    }
    
    private func requestFacebookProfile() {
//        loginView.willStartRequest()
        Profile.loadCurrentProfile { (profile, error) in
            if (error != nil) {
                return
            }
            if let uProfile = profile {
                print("FB : \(uProfile.userID)")
//                self.requestLoginFB(fbId: uProfile.userID)
            }
        }
    }
    
    func loginGoogle(viewController : LoginViewController){
        GIDSignIn.sharedInstance().clientID = "1004815788275-e08bd4lnqptuscqg5nq0acohrcu2f3jg.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
        GIDSignIn.sharedInstance().signIn()
    }

    
    func loginApple(window : UIWindow) {
        self.window = window
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }else {
            print("Login ok")
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Did login by apple")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.window
    }
    
}
