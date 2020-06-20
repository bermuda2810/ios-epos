//
//  FirestoreHelper.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/19/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Firebase

class FirestoreHelper {
    
    private var firestore : Firestore!
    
    
    init(_ firestore : Firestore) {   
        self.firestore = firestore
    }
    
    func sendTextMessage(message : TextMessage,
                         completion :@escaping (_ message :TextMessage) -> Void,  fail :@escaping (_ messageError : String) -> Void) {
        var ref: DocumentReference? = nil
        ref = firestore.collection("messages").addDocument(data: [
            "sender": message.sender as Any,
            "message": message.content as String,
            "timestamp": message.timestamp as Any,
            "type" : MessageType.TEXT
        ]) {err in
            if let err = err {
                fail("Error adding document: \(err)")
            } else {
                print("Document 1 added with ID: \(ref!.documentID)")
                message.documentId = ref!.documentID
                completion(message)
            }
        }
    }
}
