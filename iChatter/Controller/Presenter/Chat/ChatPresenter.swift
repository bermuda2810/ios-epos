//
//  ChatPresenter.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/15/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Firebase

protocol ChatView {
    func onStartingSendMessage(message : String)
    func onReceiveMessage(message : String)
    func onMessageSent(message : BaseMessage)
    func onTypingEvent(event : Int)
    func onError(message : String)
}

class ChatPresenter: NSObject {
    private var view : ChatView!
    private var firestore : Firestore!
    
    init(view : ChatView) {
        super.init()
        self.view = view
        self.firestore = Firestore.firestore()
        self.listenIncomingMessage()
    }
    
    func sendTextMessage(message : String?) {
        if message == nil {
            return
        }
        let sender = Firebase.Auth.auth().currentUser?.uid
        
        let textMessage = TextMessage()
        textMessage.sender = sender!
        textMessage.content = message!
        textMessage.timestamp = Date.init().timeIntervalSinceNow
        textMessage.cellIdentifier = "OutgoingTextMessageCell"
        
        FirestoreHelper(firestore).sendTextMessage(message: textMessage, completion: { [unowned self] (message) in
            self.view.onMessageSent(message: message)
        }) { [unowned self] (errorMessage) in
            self.view.onError(message: errorMessage)
        }
    }

    
    func readMessages() {
        firestore.collection("messages").getDocuments { (query, error) in
            if error != nil {
                print("Reading error")
            }else {
                for document in query!.documents {
                    let data = document.data()
//                    print(data["first"] as! String)
                }
            }
        }
        
    }
    
    private func listenIncomingMessage() {
        firestore.collection("messages").addSnapshotListener(includeMetadataChanges: true) { (query, error) in
//            print("Count \(query!.documents.count)")
//            for document in query!.documents {
//                let data = document.data()
//                print("Sender ID : \(data["sender"] as! String)")
//                print(data["message"] as! String)
//            }
        }
        
    }
}
