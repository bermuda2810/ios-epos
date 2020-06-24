//
//  ChatViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/28/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatViewController: BaseViewController {
    
    private var presenter : ChatPresenter!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var edtTextMessage: UITextField!
    @IBOutlet weak var cstBottomMargin: NSLayoutConstraint!
    
    private var heightTabbar : Int = 0
    private var me : String!
    private var messages : Array<BaseMessage> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ChatPresenter(view: self)
        presenter.readMessages()
        tblChat.delegate = self
        tblChat.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        tblChat.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTapped() {
        clearTextChat()
    }
    
    @IBAction func onSendPressed(_ sender: Any) {
        presenter.sendTextMessage(message: edtTextMessage.text)
        edtTextMessage.text = ""
    }
    
    private func clearTextChat() {
        edtTextMessage.text = ""
        edtTextMessage.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardView()
    }
    
    
    override func onKeyboardViewChanged(_ show : Bool,
                         _ heightTabbar : Float,
                         _  heightKeyboard : Float,
                         _ animationTime : Double) {
        let changeInHeight = (heightKeyboard - heightTabbar) * (show ? 1 : 0)
        self.cstBottomMargin?.constant = CGFloat(changeInHeight)
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    override func onKeyboardDidShow() {
        let lastIndexPath = IndexPath(row: messages.count - 1, section: 0)
        tblChat.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
}

extension ChatViewController : ChatView {
    
    func onReceiveMessages(messages: Array<BaseMessage>, indexPaths: Array<IndexPath>) {
        self.messages = messages
        tblChat.insertRows(at: indexPaths, with: .fade)
        if indexPaths.count == 0 {
            return
        }
        tblChat.scrollToRow(at: indexPaths.last!, at: .bottom, animated: true)
    }
    
    func onStartingSendMessage(message: String) {
        
    }
    
    func onLoadMessages(messages: Array<BaseMessage>) {
        self.messages = messages
        self.tblChat.reloadData()
        let indexPath = IndexPath.init(item: self.messages.count - 1, section: 0)
        tblChat.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    

    func onMessageSent(message: BaseMessage) {
        messages.append(message)
        message.indexMessage = messages.count - 1
        let indexPath = IndexPath.init(item: message.indexMessage, section: 0)
        tblChat.insertRows(at: [indexPath], with: .fade)
    }
    
    func onTypingEvent(event: Int) {
        
    }
    
    func onError(message: String) {
        
    }
}


extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: message.cellIdentifier) as! BaseMessageViewCell
        cell.bindData(message: message)
        return cell
    }
}
