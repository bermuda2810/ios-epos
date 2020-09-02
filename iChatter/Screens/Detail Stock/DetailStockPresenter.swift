//
//  DetailStockPresenter.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

protocol DetailStockView: BaseView {
    func onHistoryStockLoaded(_ sesions : Array<Session>)
    func onStockPriceUpdated(_ stock : Stock)
    func onStockProfileLoaded(_ stock : Stock)
}

class DetailStockPresenter: BasePresenter {
    
    private var view : DetailStockView!
    private var timer : Timer?
    private var stock : Stock!
    private let interval15seconds : TimeInterval = 30
    
    init(_ view: DetailStockView, _ stock : Stock) {
        super.init(view)
        self.view = view
        self.stock = stock
        startTimer()
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    private func startTimer() {
        timer?.invalidate()
        if (stock.favourite == 1) {
            timer = Timer.scheduledTimer(timeInterval: interval15seconds, target: self, selector: #selector(onRefreshPrice), userInfo: nil, repeats: true)
        }
    }
    
    
    @objc private func onRefreshPrice() {
        self.requestPriceStock(self.stock)
    }

    
    private func requestPriceStock(_ stock : Stock) {
        let task = GetRealTimePriceTask(stock: stock)
        super.requestApi(api: task, completion: { [unowned self] (stock) in
            self.view.onStockPriceUpdated(stock)
        }) { (errorCode, errorMessage) in
            print(errorMessage)
        }
    }
    
    
    func requestProfileStock(stock : Stock) {
        let task = GetStockProfile(stock: stock)
        super.requestApi(api: task, completion: { [unowned self] (stock) in
            self.view.onStockProfileLoaded(stock)
        }) { (errorCode, errorMessage) in
            print(errorMessage)
        }
    }
    
    
    func requestHistoryStock(fromDate : String, toDate : String) {
        let task = GetStockHistoryTask(stock: stock, fromDate: fromDate, toDate: toDate)
        super.requestApi(api: task, completion: { [unowned self] (sessions) in
            self.view.onHistoryStockLoaded(sessions)
        }) { (errorCode, errorMessage) in
            print(errorMessage)
        }
    }
}
