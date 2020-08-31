//
//  PRManager.swift
//  Project
//
//  Created by Bui Quoc Viet on 6/30/18.
//  Copyright © 2018 Mobile Team. All rights reserved.
//

import UIKit
import SQLite

class DatabaseManager {
    
    public static var databasePath : String!
    private static var version : Int = 1
    private static var dbName : String = "stock.db"
    
    public static func initialDatabase() {
        let copied = UserDefaults.standard.bool(forKey: "DatabaseCopied")
        if copied {
            let fileManager = FileManager.default
            let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask)
            let databaseURL = documentsUrl.first!.appendingPathComponent(dbName)
            DatabaseManager.databasePath = databaseURL.absoluteString
            checkUpgradeDatabase()
        }else {
            DatabaseManager.moveFilesFromBundleToDisk()
            saveCurrentVersionDB()
        }
        print("" + DatabaseManager.databasePath)
    }
    
    private static func moveFilesFromBundleToDisk() {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        let databaseURL = documentsUrl.first!.appendingPathComponent(dbName)
        let rs = self.copyBundleToDisk(fileName: dbName, dest: databaseURL)
        if rs == true {
            DatabaseManager.databasePath = databaseURL.absoluteString
            UserDefaults.standard.set(true, forKey: "DatabaseCopied")
            UserDefaults.standard.set(DatabaseManager.databasePath, forKey: "DatabaseURL")
            UserDefaults.standard.synchronize()
//            print("Copied \(DatabaseManager.databasePath)")
        }
    }
    
    private static func copyBundleToDisk(fileName : String, dest : URL) -> Bool {
        if !( (try? dest.checkResourceIsReachable()) ?? false) {
            let fileManager = FileManager.default
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(fileName)
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: dest.path)
                return true
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
                return false
            }
        }else {
            print("\(fileName) exist in documents folder")
            return true
        }
    }

    public func getFullPathByName(fileName : String) -> String {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        let fileURL = documentsUrl.first!.appendingPathComponent(fileName)
        return fileURL.absoluteString
    }
    
    private static func checkUpgradeDatabase() {
        let upgraded = patchDatabase()
        if upgraded {
            saveCurrentVersionDB()
        }
    }
    
    private static func saveCurrentVersionDB() {
        UserDefaults.standard.set(version, forKey: "Database Version")
        UserDefaults.standard.synchronize()
    }
    
    private static func patchDatabase() -> Bool{
//        _ needUpgrade = false
//        _ = UserDefaults.standard.integer(forKey: "Database Version") //1
//        do {
//            let database = try Connection(DatabaseManager.databasePath)
//            if lastVersion < 2 {
//                needUpgrade = true
//                patchVersion2(database)
//            }
//        }catch {
//            print("Connection to DB has failed")
//        }
        return false
    }
}
