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
    func onLoadMessages(messages : Array<BaseMessage>)
    func onReceiveMessages(messages : Array<BaseMessage>, indexPaths : Array<IndexPath>)
    func onMessageSent(message : BaseMessage)
    func onTypingEvent(event : Int)
    func onError(message : String)
}

class ChatPresenter: NSObject {
    
    private var view : ChatView!
    private var firestore : Firestore!
    private var me : String!
    private var currentMessages : Array<BaseMessage>! = Array()
    
    init(view : ChatView) {
        super.init()
        self.view = view
        self.me = Auth.auth().currentUser?.uid
        self.firestore = Firestore.firestore()
    }
    
    func sendTextMessage(message : String?) {
        if message == nil {
            return
        }
        let sender = Auth.auth().currentUser?.uid
        
        let textMessage = TextMessage()
        textMessage.sender = sender!
        textMessage.content = message!
        textMessage.timestamp = Date().timeIntervalSinceNow
        
        FirestoreHelper(firestore).sendTextMessage(message: textMessage, completion: { (message) in
            print("Sent")
        }) { [unowned self] (errorMessage) in
            self.view.onError(message: errorMessage)
        }
    }

    func readMessages() {
        firestore.collection("messages").getDocuments { [unowned self] (query, error) in
            if error != nil {
                print("Reading error")
            }else {
                self.currentMessages = self.parseMessagesFromDocuments(query)
                self.view.onLoadMessages(messages: self.currentMessages)
                self.listenIncomingMessage()
            }
        }
    }
    
    
    private func parseMessagesFromDocuments(_ query : QuerySnapshot?) -> Array<BaseMessage> {
        var messages = Array<BaseMessage>()
        for document in query!.documents {
            let data = document.data()
            let type = data["type"] as! Int
            let message = self.parseMessageByType(type: type, data: data as NSDictionary)
            message.documentId = document.documentID
            messages.append(message)
        }
        return messages
    }
    
    private func listenIncomingMessage() {
        print("listenIncomingMessage")
        firestore.collection("messages").addSnapshotListener(includeMetadataChanges: true) { [unowned self] (query, error) in
            let napshotMessages = self.parseMessagesFromDocuments(query)
            self.filterNewMessage(napshotMessages)
        }
    }
    
    private func filterNewMessage(_ snapShotMessages : Array<BaseMessage>) {
        var newMessages = Array<BaseMessage>()
        let NO_DIFFERENT = 0
        
        for message in snapShotMessages {
            var different = currentMessages.count
            for currentMessage in currentMessages {
                if message.documentId == currentMessage.documentId {
                    break
                }else {
                    different = different - 1
                }
            }
            if different == NO_DIFFERENT {
                newMessages.append(message)
            }
        }
        
        var currentIndex = self.currentMessages.count - 1
        var indexPaths = Array<IndexPath>()
        for message in newMessages {
            currentMessages.append(message)
            currentIndex = currentIndex + 1
            let indexPath = IndexPath.init(item: currentIndex, section: 0)
            indexPaths.append(indexPath)
        }
        
        view.onReceiveMessages(messages: currentMessages, indexPaths: indexPaths)
    }
    
    private func parseMessageByType(type : Int , data : NSDictionary) -> BaseMessage {
        switch type {
        case MessageType.TEXT:
            return parseTextMessage(data)
        case MessageType.IMAGE:
            return parseImageMessage(data)
        default:
            return BaseMessage()
        }
    }
    
    private func parseTextMessage(_ data : NSDictionary) -> TextMessage {
        let sender = data["sender"] as! String
        let message = data["message"] as! String
        let textMessage = TextMessage()
        textMessage.content = message
        textMessage.sender = sender
        if sender == me {
            textMessage.cellIdentifier = Identifider.outgoingTextMessage.rawValue
        }else {
            textMessage.cellIdentifier = Identifider.incommingTextMessage.rawValue
        }
        return textMessage
    }
    
    private func parseImageMessage(_ data : NSDictionary) -> ImageMessage {
        return ImageMessage()
    }
 }
