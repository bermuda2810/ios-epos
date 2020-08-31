//
//  GetRealTimePriceTask.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetRealTimePriceTask: BaseTask<Stock>, TaskDatasource {
    
    private var stock : Stock!
    
    init(stock : Stock) {
        self.stock = stock
    }
    
    func method() -> HTTPMethod {
        return HTTPMethod.get
    }
    
    func api() -> String {
        let api = String.init(format: "%@/%@", Api.realTimePrice, self.stock.symbol)
        return api
    }
    
    func parameters() -> Parameters? {
        return nil
    }
    
    func onParseDataByResponse(_ response: JSON) throws -> Any {
        stock.price = response[0]["price"].doubleValue
        return stock as Any
    }
    
    func paramEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
}
