//
//  GetListCompanyTask.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetListStockTask: BaseTask<Array<Stock>>, TaskDatasource {
    
    func method() -> HTTPMethod {
         return HTTPMethod.get
    }
    
    func api() -> String {
        return Api.listStock
    }
    
    func parameters() -> Parameters? {
        return nil
    }
    
    func onParseDataByResponse(_ response: JSON) throws -> Any {
        var stocks: Array<Stock> = []
        for i in (0...response.array!.count){
            let stock = Stock()
            let jStock : JSON = response[i]
            stock.symbol = jStock["symbol"].stringValue
            stock.name = jStock["name"].stringValue
            stock.price = jStock["price"].doubleValue
            stock.exchange = jStock["exchange"].stringValue
            stocks.append(stock)
        }
        return stocks
    }
    
    func paramEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }

}
