//
//  DetailStockPresenter.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

protocol DetailStockView: BaseView {
    func onStockPriceUpdated(_ stock : Stock)
    func onStockProfileLoaded(_ stock : Stock)
}

class DetailStockPresenter: BasePresenter {
    
    private var view : DetailStockView!
    
    
    init(_ view: DetailStockView) {
        super.init(view)
        self.view = view
    }
    

    func requestPriceStock(_ stock : Stock) {
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
}
