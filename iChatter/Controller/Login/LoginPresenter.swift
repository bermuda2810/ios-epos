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
import CryptoKit


protocol LoginView : BaseView {
    func onLoginSuccess()
    func onLoginFail(message : String)
    func onStartLogin()
}

class LoginPresenter : BasePresenter {
    
    private weak var window : UIWindow!
    private var loginView : LoginView!
    fileprivate var currentNonce: String?
    
    var name : String!
    
    init(view : LoginView) {
        super.init(view)
        self.loginView = view
    }
    
    //MARK: - Request Login
    
    func requestLoginByAccount(username : String, password : String) {
        let request = LoginTask(username: username, password: password)
        super.requestApi(api: request, completion: { (result) in
            print("Login success!!!")
        }) { (code, message) in
            print(message)
        }
    }
    
    func requestLoginFacebook() {
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
        GIDSignIn.sharedInstance().presentingViewController = vc
        GIDSignIn.sharedInstance().signIn()
    }
    
    func requestLoginApple() {
        let vc = loginView as? UIViewController
        self.window = vc?.view.window
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
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
        Auth.auth().signIn(with: credential) { [unowned self] (authResult, error) in
            if (error != nil) {
                self.loginView?.onLoginFail(message: error.debugDescription)
            }else {
                self.markLogined()
                self.loginView?.onLoginSuccess()
            }
        }
    }
    
    private func markLogined() {
        UserDefaults.standard.set(true, forKey: AuthCode.LOGIN)
    }
}

// MARK: - Google Login's Delegate
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


// MARK: - Apple Login's Delegate
extension LoginPresenter : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
            self.loginView.onLoginFail(message: "Invalid state")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            self.loginView.onLoginFail(message: "Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            self.loginView.onLoginFail(message: "Unable to serialize token string from data")
            return
          }
          // Initialize a Firebase credential.
          let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
            authWithFirebase(credential: credential)
          }
        }
    
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
