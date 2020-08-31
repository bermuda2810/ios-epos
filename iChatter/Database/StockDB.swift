//
//  StockDB.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import SQLite

class StockDB: BaseRequestDB {
    
    private let colId = Expression<Int>("id")
    private let colSymbol = Expression<String>("symbol")
    private let colName = Expression<String>("name")
    private let colPrice = Expression<Double>("price")
    private let colExchange = Expression<String>("exchange")
    private let colFavourite = Expression<Int>("favourite")
    private var stocks : Table!
    
    override init() {
        super.init()
        initTable()
    }
    
    private func initTable() {
        stocks = Table("stock")
        do {
            try database.run(stocks.create(ifNotExists : true) { t in
                t.column(colId)
                t.column(colSymbol)
                t.column(colName)
                t.column(colPrice)
                t.column(colExchange)
            })
        } catch {
            print("Init table stock failed")
        }
    }
    
    func saveStocks(_ data : Array<Stock>) {
        do {
            for stock in data {
                let insert = stocks.insert(colSymbol <- stock.symbol,
                                               colName <- stock.name,
                                               colPrice <- stock.price,
                                               colExchange <- stock.exchange,
                                               colFavourite <- stock.favourite)
                try database.run(insert)
            }
        } catch {
            print("Insert to stock error")
        }
    }
    
    func updateFavourite(_ data : Stock) {
        do {
            let stock = stocks.filter(colId == data.id)
            try database.run(stock.update(colFavourite <- data.favourite))
        }catch {
            print("Update stock failed")
        }
    }
    
    func checkExist() -> Bool {
        do {
            let query = stocks.count
            let count = try database.scalar(query)
            return count > 0 ? true : false
        }catch {
            return false
        }
    }
    
    func getStocks() -> Array<Stock> {
        var data = Array<Stock>()
        do {
            for row in try database.prepare(stocks.order(colId)) {
                let stock = Stock()
                stock.id = row[colId]
                stock.symbol = row[colSymbol]
                stock.name = row[colName]
                stock.price = row[colPrice]
                stock.exchange = row[colExchange]
                stock.favourite = row[colFavourite]
                data.append(stock)
            }
        }catch {
            print("Query stocks failed")
        }
        return data
    }
    
    func getStock(offset : Int, limit : Int, favourite : Int) -> Array<Stock> {
        var data = Array<Stock>()
        do {
            let profiles = Table("profile")
            let stockId  = Expression<Int>("stock_id")
            for row in try database.prepare(stocks.join(.leftOuter, profiles, on: stocks[colId] == profiles[stockId])
                .where(stocks[colFavourite] == favourite)
                .limit(limit, offset: offset)) {
                    
                let stock = Stock()
                stock.id = row[stocks[colId]]
                stock.symbol = row[stocks[colSymbol]]
                stock.name = row[stocks[colName]]
                stock.price = row[stocks[colPrice]]
                stock.exchange = row[stocks[colExchange]]
                stock.favourite = row[stocks[colFavourite]]
                let profileId = row[profiles[Expression<Int?>("id")]]
                if let profileId = profileId {
                    let profile = Profile()
                    profile.id = profileId
                    profile.image = row[profiles[Expression<String?>("image")]]
                    profile.changesPercentage = row[profiles[Expression<String?>("changes_percentage")]]
                    profile.companyName = row[profiles[Expression<String?>("company_name")]]
                    profile.price = row[profiles[Expression<Double?>("price")]] ?? 0.0
                    profile.stockId = row[profiles[Expression<Int?>("stock_id")]] ?? 0
                    stock.profile = profile
                }
                data.append(stock)
            }
        }catch {
            print("Query stocks failed")
        }
        return data
    }
}
