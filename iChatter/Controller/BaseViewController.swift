//
//  BaseViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/8/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController, CommonView {
    
    private var hud : JGProgressHUD?
    var titleNavigation : String? { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = titleNavigation {
            self.title = title
        }
        self.navigationController?.navigationBar.tintColor = UIColor.black // for all text on Navigation Bar
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black // Only for title
        ]
    }
    
    //MARK: - Dialog Waiting
    func showWaitingDialog() {
        hud = JGProgressHUD(style: .dark)
        hud!.textLabel.text = "Loading"
        hud!.show(in: self.view)
    }
    
    func showDialogWithMessage(_ message : String) {
        hud = JGProgressHUD(style: .dark)
        hud!.textLabel.text = message
        hud!.show(in: self.view)
    }
    
    func hideWaitingDialog() {
        hud?.dismiss()
    }
    
    func postNotificationCenter(channel : String, data : Any?) {
        var notification : Notification = Notification(name: Notification.Name.init(rawValue: channel))
        notification.object = data
        NotificationCenter.default.post(notification)
    }
    
    //MARK: - Keyboard notifications
    
    func unregisterKeyboardView() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    func registerKeyboardView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        handleWhenKeyboardChanged(false, notification: notification)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        handleWhenKeyboardChanged(true, notification: notification)
    }
    
    @objc func keyboardDidShow(_ notification:Notification) {
        print("keyboardDidShow")
        self.onKeyboardDidShow()
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        handleWhenKeyboardChanged(false, notification: notification)
    }
    
    private func handleWhenKeyboardChanged(_ show : Bool, notification:Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let heightTabbar = self.tabBarController != nil ? self.tabBarController?.tabBar.frame.size.height : 0
        
        self.onKeyboardViewChanged(show,
                                   Float(heightTabbar!),
                                   Float(keyboardFrame.size.height),
                                   animationDurarion)
    }
    
    
    /**
     @show : Bool When keyboard is showing that show is true and otherwise
     */
    func onKeyboardViewChanged(_ show:Bool,
                               _ heightTabbar : Float,
                               _  heightKeyboard : Float,
                               _ animationTime : Double) {
    }
    
    func onKeyboardDidShow() {
        
    }
    
    func onConnectionTimeout() {
        self.hideWaitingDialog()
    }
    
    func onWrongResponseFormat() {
        self.hideWaitingDialog()
        self.showDialogWithMessage("Code :9999 - Wrong response format")
    }
}
