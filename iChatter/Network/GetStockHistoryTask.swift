//
//  GetStockHistoryTask.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 9/1/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetStockHistoryTask: BaseTask<Array<Session>>, TaskDatasource {
    
    private var stock : Stock!
    private var fromDate : String!
    private var toDate : String!
    
    init(stock : Stock, fromDate : String, toDate : String) {
        self.stock = stock
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    func method() -> HTTPMethod {
        return HTTPMethod.get
    }
    
    func api() -> String {
        let api = String.init(format: "%@/%@", Api.historicalPrice, self.stock.symbol)
        return api
    }
    
    func parameters() -> Parameters? {
        return ["from" : fromDate as Any,
                "to" : toDate as Any]
    }
    
    func onParseDataByResponse(_ response: JSON) throws -> Any {
        var sessions : Array<Session> = []
        let jSessions = response["historical"].array
        if let jSessions = jSessions {
            for i in (0...jSessions.count) {
                let session = Session()
                session.date = jSessions[i]["data"].stringValue
                session.open = jSessions[i]["open"].doubleValue
                session.high = jSessions[i]["high"].doubleValue
                session.low = jSessions[i]["low"].doubleValue
                session.close = jSessions[i]["close"].doubleValue
                session.adjClose = jSessions[i]["adjClose"].doubleValue
                session.volume = jSessions[i]["volume"].intValue
                session.unadjustedVolume = jSessions[i]["unadjustedVolume"].intValue
                session.change = jSessions[i]["change"].doubleValue
                session.changePercent = jSessions[i]["changePercent"].doubleValue
                session.vwap = jSessions[i]["vwap"].doubleValue
                session.label = jSessions[i]["label"].stringValue
                session.changeOverTime = jSessions[i]["changeOverTime"].doubleValue
                sessions.append(session)
            }
        }
        return sessions
    }
    
    func paramEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
}
