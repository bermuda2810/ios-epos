//
//  ProfileDB.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import SQLite

class ProfileDB: BaseRequestDB {
    
    private let colId = Expression<Int>("id")
    private let colStockId = Expression<Int>("stock_id")
    private let colPrice = Expression<Double>("price")
    private let colChangesPercentage = Expression<String>("changes_percentage")
    private let colCompanyName = Expression<String>("company_name")
    private let colImage = Expression<String>("image")
    private var table : Table!
    
    override init() {
        super.init()
        initTable()
    }
    
    private func initTable() {
        table = Table("profile")
        do {
            try database.run(table.create(ifNotExists : true) { t in
                t.column(colId)
                t.column(colStockId)
                t.column(colPrice)
                t.column(colChangesPercentage)
                t.column(colCompanyName)
                t.column(colImage)
            })
        } catch {
            print("Init table Profile failed")
        }
    }
    
    func saveProfile(_ profiles : Array<Profile>) {
        do {
//            let stocks = Table("stock")
            for profile in profiles {
                //                for stock in try  database.prepare(stocks.filter(Expression<String>("symbol") == profile.symbol)) {
                //                    let stockId = stock[Expression<Int>("id")]
                let insert = table.insert(colStockId <- profile.stockId,
                                          colPrice <- profile.price,
                                          colChangesPercentage <- profile.changesPercentage ?? "",
                                          colCompanyName <- profile.companyName ?? "",
                                          colImage <- profile.image ?? "")
                try database.run(insert)
                //                }
            }
        } catch {
            print("Insert to profile error")
        }
    }
    
    func checkExist() -> Bool {
        do {
            let query = table.count
            let count = try database.scalar(query)
            return count > 0 ? true : false
        }catch {
            return false
        }
    }
    
    func getProfile(sockId : Int) -> Profile? {
        do {
            for row in try database.prepare(table.order(colId)) {
                let profile = Profile()
                profile.id = row[colId]
                profile.stockId = row[colStockId]
                profile.changesPercentage = row[colChangesPercentage]
                profile.image = row[colImage]
                return profile
            }
        }catch {
            print("Query stocks failed")
        }
        return nil
    }
}
