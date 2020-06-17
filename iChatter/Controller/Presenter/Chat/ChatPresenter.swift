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
    func onMessageSent(message : String)
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
    
    func sendMessage(message : String) {
        
        var ref: DocumentReference? = nil
        ref = firestore.collection("messages").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815,
            "message": message
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func readMessages() {
        firestore.collection("messages").getDocuments { (query, error) in
            if error != nil {
                print("Reading error")
            }else {
                for document in query!.documents {
                    let data = document.data()
                    print(data["first"] as! String)
                }
            }
        }
    }
    
    private func listenIncomingMessage() {
        print("I'm listening new message")
        firestore.collection("messages").addSnapshotListener(includeMetadataChanges: true) { (query, error) in
            for document in query!.documents {
                let data = document.data()
                print(data["message"] as! String)
            }
        }
    }
}
