//
//  GetStockProfile.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetStockProfile: BaseTask<Stock>, TaskDatasource {
    
    private var stock : Stock!
    
    init(stock : Stock) {
        self.stock = stock
    }
    
    func method() -> HTTPMethod {
        return HTTPMethod.get
    }
    
    func api() -> String {
        let api = String.init(format: "%@/%@", Api.profile, self.stock.symbol)
        return api
    }
    
    func parameters() -> Parameters? {
        return nil
    }
    
    func onParseDataByResponse(_ response: JSON) throws -> Any {
        let profile = Profile()
        profile.changesPercentage = response[0]["changesPercentage"].stringValue
        profile.image = response[0]["image"].stringValue
        profile.companyName = response[0]["companyName"].stringValue
        profile.price = response[0]["price"].doubleValue
        profile.changes = response[0]["changes"].doubleValue
        profile.lastDiv = response[0]["lastDiv"].intValue
        profile.industry = response[0]["industry"].stringValue
        profile.sector = response[0]["sector"].stringValue
        profile.symbol = response[0]["symbol"].stringValue
        stock.profile = profile
        return stock as Any
    }
    
    func paramEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
}
