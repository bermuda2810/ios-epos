//
//  ChatViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/28/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController {
    
    private var presenter : ChatPresenter!
    
    @IBOutlet weak var cstBottomMargin: NSLayoutConstraint!
    private var heightTabbar : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ChatPresenter(view: self)
    }
    
    @IBAction func onSendPressed(_ sender: Any) {
        presenter.sendMessage(message: "VietBQ")
//        presenter.readMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardView()
    }
    
    
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
           adjustingHeight(false, notification: notification)
       }
       
       @objc func keyboardWillShow(_ notification:Notification) {
           adjustingHeight(true, notification: notification)
       }
       
       @objc func keyboardDidShow(_ notification:Notification) {
           print("keyboardDidShow")
       }
       
       @objc func keyboardWillChangeFrame(_ notification: Notification) {
           adjustingHeight(false, notification: notification)
       }
    
    
    func adjustingHeight(_ show:Bool, notification:Notification) {
           let userInfo = (notification as NSNotification).userInfo!
           let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
           let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
           let heightTabbar = self.tabBarController != nil ? self.tabBarController?.tabBar.frame.size.height : 0
           let changeInHeight = (keyboardFrame.size.height - heightTabbar!) * (show ? 1 : 0)
           self.cstBottomMargin?.constant = changeInHeight
           UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
               self.view.layoutIfNeeded()
           })
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController : ChatView {
    func onStartingSendMessage(message: String) {
        
    }
    
    func onReceiveMessage(message: String) {
        
    }
    
    func onMessageSent(message: String) {
        
    }
    
    func onTypingEvent(event: Int) {
        
    }
    
    func onError(message: String) {
        
    }
}
