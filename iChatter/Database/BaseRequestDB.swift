//
//  BaseRequestDB.swift
//  MyBill
//
//  Created by Bui Quoc Viet on 2/8/18.
//  Copyright © 2018 Mobile Team. All rights reserved.
//

import SQLite

class BaseRequestDB {
    
    var database : Connection!
    let version : Int = 1
    
    init() {
        openDatabase()
    }
    
    deinit {
        closeDatabase()
    }
    
    private func openDatabase() {
        do {
            self.database = try Connection(DatabaseManager.databasePath)
            print("Connected to Database")
        }catch {
            print("Connect database failed")
        }
    }

    private func closeDatabase() {
        print("Close to Database")
        self.database = nil
    }
}
