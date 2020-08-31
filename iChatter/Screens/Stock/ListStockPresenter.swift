//
//  ListCompanyPresenter.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

protocol ListStockView: BaseView {
    func onStockUpdated(_ stock : Stock)
    func onNewStocks(stocks : Array<Stock>)
    func onLoadMoreStocks(stocks : Array<Stock>)
    func onLoadFail(_ errorCode : Int, _ errorMessage : String)
}


class ListStockPresenter: BasePresenter {
    
    private var view : ListStockView!
    private var offset : Int!
    private var limit : Int!
    
    init(_ view: ListStockView) {
        super.init(view)
        self.view = view
        self.offset = 0
        self.limit = 50
    }
    
    func requestListStock(_ favourite : Int) {
        offset = 0
        let stocks = getStockFromDatabase(favourite)
        offset = offset + stocks.count
        self.view.onNewStocks(stocks: stocks)
    }
    
    func requestMoreStocks(_ favourite : Int) {
        let stocks = getStockFromDatabase(favourite)
        offset = offset + stocks.count
        self.view.onLoadMoreStocks(stocks: stocks)
    }
    
    private func getStockFromDatabase(_ favourite : Int) -> Array<Stock>{
        let stockDB = StockDB()
        let stocks = stockDB.getStock(offset: offset, limit: limit, favourite: favourite)
        return stocks
    }
    
    func requestProfile(stock : Stock) {
        let task = GetStockProfile(stock: stock)
        super.requestApi(api: task, completion: { [unowned self] (stock) in
            self.saveProfileToDatabase(stock)
            self.view.onStockUpdated(stock)
        }) { [unowned self] (errorCode, errorMessage) in
//            self.view.onLoadFail(errorCode, errorMessage)
        }
    }
    
    func requestUpdateStock(stock : Stock) {
        let stockDB = StockDB()
        stockDB.updateFavourite(stock)
    }
    
    private func saveProfileToDatabase(_ stock : Stock) {
        let profileDB = ProfileDB()
        profileDB.saveProfile([stock.profile!])
    }
}
