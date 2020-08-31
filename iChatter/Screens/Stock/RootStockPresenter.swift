//
//  RootStockPresenter.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

protocol RootStockView: BaseView {
    func onStartLoadStock()
    func onReady()
    func onLoadFail(_ errorCode : Int, _ errorMessage : String)
}

class RootStockPresenter: BasePresenter {
    
    private var view : RootStockView!
    
    init(_ view: RootStockView) {
        super.init(view)
        self.view = view
    }
    
    func requestListStock() {
        if !existOnDatabase() {
            self.view.onStartLoadStock()
            requestListStockFromServer()
        }else {
            self.view.onReady()
        }
    }
    
    private func existOnDatabase() -> Bool {
        let stockDB = StockDB()
        if (stockDB.getStocks().count > 0) {
            print("Stock already exist Database")
            return true
        }else {
            print("Stock not exist")
            return false
        }
    }
    
    private func requestListStockFromServer() {
        let task = GetListStockTask()
        super.requestApi(api: task, completion: { [unowned self] (stocks) in
            self.cacheStockToDatabase(stocks)
        }) { [unowned self] (errorCode, errorMessage) in
            self.view.onLoadFail(errorCode, errorMessage)
        }
    }
    
    private func cacheStockToDatabase(_ stocks : Array<Stock>) {
        let stockDB = StockDB()
        stockDB.saveStocks(stocks)
        self.view.onReady()
    }
}
