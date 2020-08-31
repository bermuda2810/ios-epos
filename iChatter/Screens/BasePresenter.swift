//
//  BasePresenter.swift
//  ZBot
//
//  Created by Bui Quoc Viet on 3/28/18.
//  Copyright © 2018 Mobile Team. All rights reserved.
//

import UIKit
import SnapKit

protocol BaseView: class {
}

@objc protocol CommonView: class {
    @objc optional func onConnectionTimeout()
    @objc optional func onNoConnection()
    @objc optional func onAuthError()
    @objc optional func onWrongResponseFormat()
}

class BasePresenter : NSObject {
    
    private weak var view : CommonView!
    
    init(_ view : BaseView) {
        self.view = view as? CommonView
    }
         
    func requestApi <T>(api : BaseTask <T>, completion : @escaping (_ result :T) -> Void,
                        fail : @escaping (_ code : Int, _ message : String) -> Void) {
        api.requestAPI(blockSuccess: completion) { [unowned self] (code, message) in
            self.handleCommonError(code, message, fail)
        }
    }
    
    private func handleCommonError(_ code : Int,
                                   _ message : String,
                                   _ fail : @escaping (_ code : Int, _ message : String) -> Void) {
        if (code == ResponseCode.timeout) {
            self.view.onConnectionTimeout?()
        }else if (code == ResponseCode.errorAuth) {
            self.view.onAuthError?()
        }else if (code == ResponseCode.wrongResponseFormat) {
            self.view.onWrongResponseFormat?()
        }else {
            fail(code, message)
        }
    }
}
