//
//  BaseTask.swift
//  vidoc
//
//  Created by Bui Quoc Viet on 3/1/17.
//  Copyright © 2017 Mobile Team. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol TaskDatasource {
    func method() -> HTTPMethod
    func api() -> String
    func parameters() -> Parameters?
    func onParseDataByResponse(_ response : JSON) throws -> Any
    func paramEncoding() -> ParameterEncoding
}

class BaseTask<T> {
    private var dataSource : TaskDatasource {
        (self as! TaskDatasource)
    }
    
    private var blockSuccess : ((_ result :T) -> Void)!
    private var blockFailure : ((_ errorCode :Int, _ errorMessage :String) -> Void)?
    
    
    public func requestAPI(blockSuccess :@escaping (_ result :T) -> Void ,
                           blockFailure :@escaping (_ errorCode :Int,_ errorMessage :String) -> Void) {
        
        self.blockSuccess = blockSuccess
        self.blockFailure = blockFailure
        
        let headers: HTTPHeaders = self.getDefaultHeaders()
        let method: HTTPMethod = dataSource.method()
        let url:URLConvertible = self.genURL()
        let params: Dictionary = self.genParams()
        let encoding : ParameterEncoding = dataSource.paramEncoding()
        
        AF.request(url,
                   method: method,
                   parameters: params,
                   encoding: encoding,
                   headers: headers).responseJSON { (response) in
                    self.handleResponse(response)
        }
    }
    
    private func handleResponse(_ response :DataResponse<Any, AFError>) {
        switch (response.result) {
        case .success: //HTTP Request 200 OK
            self.handleSuccessHTTPRequest(response)
            break
        case .failure(let error): // Other HTTP Response Code 400,404...
            self.handleErrorHttpRequest(error: error)
            break
        }
    }
    
    private func requestPostMultipartForm() {
    }
    
    public func generatePostParams(params: Dictionary<String, Any>, multipartFormData : MultipartFormData) {
        for (key, value) in params {
            var paramsData: Data
            if value is Array<Dictionary<String, Any>> {
                paramsData = (value as! Array<Dictionary<String, Any>>).description.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            } else {
                paramsData = (value as! String).data(using: String.Encoding.utf8, allowLossyConversion: false)!
            }
            multipartFormData.append(paramsData, withName: key, mimeType: "Text")
        }
    }
    
    private func handleSuccessHTTPRequest(_ response :DataResponse<Any, AFError>) {
        guard let json = try? JSON(data: response.data!) else {
            self.blockFailure!(ResponseCode.wrongResponseFormat,"Reponse invalid JSON")
            return
        }
        print("Data rereived: ", json)
        if let errorMessage: String = json["Error Message"].string {
            self.blockFailure!(ResponseCode.somethingWentWrong, errorMessage)
        }else {
            do {
                let result = try dataSource.onParseDataByResponse(json)
                print("Go to success block")
                self.blockSuccess!(result as! T)
            } catch {
                self.blockFailure!(ResponseCode.parseJSONError, "Parse JSON Failed")
            }
        }
    }
    
    private func handleErrorHttpRequest(error : Error) {
        if error._code == NSURLErrorTimedOut {
            self.blockFailure?(ResponseCode.timeout, "Timeout")
        } else if error._code == NSURLErrorNotConnectedToInternet {
            self.blockFailure?(ResponseCode.noConnection, "No connection")
        } else if error._code == -1002 {
            self.blockFailure?(ResponseCode.urlNotSupport, "URL not support")
        }else {
            self.blockFailure?(9999,error.localizedDescription)
            print("\n\nAuth request failed with error:\n \(error)")
        }
    }
    
    //    private func handleResponseApi(json : JSON) {
    //        let code :Int! = json[JsonCode.statusCode].intValue
    //        if (code == ResponseCode.success) {
    //            do {
    //                let result = try dataSource.onParseDataByResponse(json)
    //                print("Go to success block")
    //                self.blockSuccess!(result as! T)
    //            } catch {
    //                self.blockFailure!(ResponseCode.parseJSONError, "Parse JSON Failed")
    //            }
    //        }else {
    //            print("Go to error block")
    //            let status = json[JsonCode.statusCode].int != nil ? json[JsonCode.statusCode].int! : ResponseCode.serverError
    //            self.blockFailure!(status, "Something went wrong")
    //        }
    //    }
    
    func genURL() -> String {
        let api :String = dataSource.api()
        let url :String = String.init(format: "%@/%@/%@", NetworkConfig.API_URL, NetworkConfig.API_VERSION, api)
        print("API requesting ", url)
        return url
    }
    
    func getDefaultHeaders() -> HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Accept" : "application/json"
        ]
    }
    
    private func genParams()  -> Parameters{
        let customParams : Parameters? = dataSource.parameters()
        if var customParams : Parameters = customParams {
            customParams["apikey"] = NetworkConfig.API_KEY
            return customParams
        }else {
            return getDefaultParams()
        }
    }
    
    private func getDefaultParams() -> Parameters {
        return ["apikey" : NetworkConfig.API_KEY]
    }
}
