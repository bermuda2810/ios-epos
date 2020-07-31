//
//  BasePresenter.swift
//  ZBot
//
//  Created by Bui Quoc Viet on 3/28/18.
//  Copyright © 2018 Mobile Team. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol BaseView {
   @objc optional func onRetry()
   @objc optional func onConnectionTimeout()
   @objc optional func onNoConnection()
   @objc optional func onAuthError()
}

class BasePresenter : NSObject {
    
    private let operationQueue : OperationQueue = OperationQueue()
    private var blockFailure :((_ errorCode :Int?, _ errorMessage :String?) -> Void)?
    
    private var baseView : BaseView!
    
    init(baseView : BaseView) {
        self.baseView = baseView
    }
         
    func requestApi <T>(api : BaseTask <T>, completion : @escaping (_ result :T) -> Void,
                        fail : @escaping (_ code : Int, _ message : String) -> Void) {
        api.requestAPI(blockSuccess: completion) { [unowned self] (code, message) in
            if (code == ResponseCode.timeout) {
                self.showAlert(ResponseCode.getMessageByCode(code))
            }else {
                fail(code, message)
            }
        }
    }
    
    private func showAlert(_ message : String) {
        let controller = baseView as! BaseViewController
        controller.showDialogWithMessage(message)
    }
    

    func showWaitingDialog() {
//        let controller = baseView as! BaseViewController
//        controller.showWaitingDialog()
    }
    
    private func handleNoConnection() {
        let baseViewController = baseView as! BaseViewController
        baseViewController.hideWaitingDialog()
//        showAlert(NetworkError.noConnection.localized)
    }
    
    private func handleTimeout() {
        let baseViewController = baseView as? BaseViewController
        if baseViewController != nil {
            baseViewController?.hideWaitingDialog()
        }
//        showAlert(NetworkError.timeout.localized)
    }
    
    private func handleAccoutAlreadyExist() {
        let baseViewController = baseView as? BaseViewController
        if baseViewController != nil {
            baseViewController?.hideWaitingDialog()
        }
//        showAlert(RegisterScreen.accountAlreadyExist.localized)
    }
    
    private func handleLoginError() {
        let baseViewController = baseView as? BaseViewController
        if baseViewController != nil {
            baseViewController?.hideWaitingDialog()
        }
//        showAlert(LoginScreen.loginFail.localized)
    }
    
    private func handleAccoutNotVerify() {
        let baseViewController = baseView as? BaseViewController
        if baseViewController != nil {
            baseViewController?.hideWaitingDialog()
        }
//        showAlert(LoginScreen.accountNotVerify.localized)
    }
    
    private func handleVerifyAccountNotOk() {
           let baseViewController = baseView as? BaseViewController
           if baseViewController != nil {
               baseViewController?.hideWaitingDialog()
           }
//           showAlert(LoginScreen.verifyAccountNotOK.localized)
       }
    
    private func handleCharacterLimited() {
            let baseViewController = baseView as? BaseViewController
            if baseViewController != nil {
                baseViewController?.hideWaitingDialog()
            }
//            showAlert(Common.characterLimited.localized)
        }
    
    private func handleAuthError() {
        let baseViewController = baseView as? BaseViewController
        if baseViewController != nil {
            baseViewController?.hideWaitingDialog()
        }
//        Authorization().deleteAuth()
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        delegate.setupRootViewController()
    }
}
