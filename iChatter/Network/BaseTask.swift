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
    func onResponse(response :JSON) throws -> Any
    func paramEncoding() -> ParameterEncoding
}

class BaseTask<T>  {
    var dataSource : TaskDatasource {
        (self as! TaskDatasource)
    }
    var blockSuccess : ((_ result :T) -> Void)!
    var blockFailure : ((_ errorCode :Int?, _ errorMessage :String?) -> Void)?
    var blockCustom  : ((_ result :T?) -> Void)?
    var bodyParams : Bool = false
    var isReceiverCustomBlock: Bool = false
    
    public func requestAPI(blockSuccess :@escaping (_ result :T?) -> Void ,
                           blockFailure : @escaping (_ errorCode :Int?,_ errorMessage :String?) -> Void, blockCustom : ((_ result :T?) -> Void)? = nil) {
        let method = dataSource.method()
        if method == HTTPMethod.post{
            self.requestPostAPI(blockSuccess: blockSuccess, blockFailure: blockFailure, blockCustom: blockCustom)
        }else if method == HTTPMethod.put || method == HTTPMethod.delete {
            self.requestPutAPI(blockSuccess: blockSuccess, blockFailure: blockFailure)
        }else {
            self.requestGetAPI(blockSuccess: blockSuccess, blockFailure: blockFailure)
        }
    }
    
    private func requestGetAPI(blockSuccess :@escaping (_ result :T?) -> Void ,
                               blockFailure : @escaping (_ errorCode :Int?,_ errorMessage :String?) -> Void) {
        
        self.blockSuccess = blockSuccess
        self.blockFailure = blockFailure
        
        let headers: HTTPHeaders = self.getDefaultHeaders()
        let method: HTTPMethod = dataSource.method()
        let url:URLConvertible = self.genURL()
        let params:Parameters? = dataSource.parameters()
        let encoding : ParameterEncoding = URLEncoding.default
        
        AF.request(url,
                          method: method,
                          parameters: params,
                          encoding: encoding,
                          headers: headers).responseJSON { (response) in
                            self.handleResponse(response)
                            
        }
    }
    
    private func requestPutAPI(blockSuccess :@escaping (_ result :T?) -> Void ,
                                blockFailure : @escaping (_ errorCode :Int?,_ errorMessage :String?) -> Void) {
        self.blockSuccess = blockSuccess
        self.blockFailure = blockFailure
        
        let headers: HTTPHeaders = self.getDefaultHeaders()
        let method: HTTPMethod = dataSource.method()
        let url:URLConvertible = self.genURL()
        let params: Dictionary = dataSource.parameters()!
        let encoding : ParameterEncoding = JSONEncoding.default
        print("params" , params.description)
        AF.request(url,
                          method: method,
                          parameters: params,
                          encoding: encoding,
                          headers: headers).responseJSON { (response) in
                            self.handleResponse(response)
        }
    }
    
    private func requestPostAPI(blockSuccess :@escaping (_ result :T?) -> Void ,
                                blockFailure : @escaping (_ errorCode :Int?,_ errorMessage :String?) -> Void, blockCustom :((_ result :T?) -> Void)? = nil) {
        self.blockSuccess = blockSuccess
        self.blockFailure = blockFailure
        self.blockCustom = blockCustom
        
        let headers: HTTPHeaders = self.getDefaultHeaders()
        let method: HTTPMethod = dataSource.method()
        let url:URLConvertible = self.genURL()
        let params: Dictionary = dataSource.parameters()!
        
        let encoding : ParameterEncoding = dataSource.paramEncoding()
        AF.request(url,
                              method: method,
                              parameters: params,
                              encoding: encoding,
                              headers: headers).responseJSON { (response) in
                            self.handleResponse(response)
                                
            }
    }
    
    private func requestPostMultipartForm() {
//                    AF.upload(multipartFormData: { (multipartFormData) in
//                        self.generatePostParams(params: params, multipartFormData: multipartFormData)
//                    }, to: url, usingThreshold: MultipartFormData.encodingMemoryThreshold, method: HTTPMethod.post, headers: headers).responseData { (response) in
//                        print("Hello")
//                    }
    }
    
    private func requestLoginAPI() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = "email=crazybjrd@gmail.com&pass=123456892@&f=user"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://hocthukhoa.vn/api.php")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
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
    
    public func requestUploadFile(fileURL : URL, blockSuccess :@escaping (_ result :T) -> Void ,
                                  blockFailure : @escaping (_ errorCode :Int?,_ errorMessage :String?) -> Void, name : String) -> Void {
        
        self.blockSuccess = blockSuccess
        self.blockFailure = blockFailure
        
        let headers: HTTPHeaders = self.getDefaultHeaders()
        let method: HTTPMethod = dataSource.method()
        let url:URLConvertible = self.genURL()
        
        let request = AF.upload(fileURL, to: url, method: method, headers: headers)
        request.responseJSON { response in
            
        }
    }
    
    private func handleResponse(_ response :DataResponse<Any, AFError>) {
        switch (response.result) {
        case .success:
            self.handleSuccess(response)
            break
        case .failure(let error):
            self.handleError(error: error)
            break
        }
    }
    
    private func handleError(error : Error) {
        if error._code == NSURLErrorTimedOut {
            self.blockFailure!(ResponseCode.timeout, "Timeout")
        } else if error._code == NSURLErrorNotConnectedToInternet {
            self.blockFailure!(ResponseCode.noConnection, "No connection")
        } else if error._code == -1002 {
            self.blockFailure!(ResponseCode.urlNotSupport, "URL not support")
        }else {
            self.blockFailure!(9999,error.localizedDescription)
            print("\n\nAuth request failed with error:\n \(error)")
        }
    }
    
    private func handleSuccess(_ response :DataResponse<Any, AFError>) {
        if(response.error == nil){
            guard let json = try? JSON(data: response.data!) else {
                self.blockFailure!(9999,"Parse Failed")
                return
            }
            print("Data rereived ", json)
            self.handleResponseOtherAPI(json: json)
        }else {
            self.blockFailure!(9999,"Request failure")
        }
    }
    
    func makeMessageFromArray(array : Array<Any>?) -> String {
        var result = ""
        if array != nil {
            let messages = array as! Array<String>
            for message in messages {
                if result == "" {
                    result = String(format: "%@", message)
                }else {
                    result = String(format: "%@\n%@",result, message)
                }
            }
        }
        return result.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    private func handleResponseOtherAPI(json : JSON) {
        let code :Int! = json[JsonCode.statusCode].intValue
        if (self.validCode(code: code)) {
            do {
                let result = try dataSource.onResponse(response: json)
                print("Go to success block")
                self.blockSuccess!(result as! T)
            } catch {
                self.blockFailure!(ResponseCode.parseJSONError, "JSON Error!")
            }
        }else {
            print("Go to error block")
            let status = json[JsonCode.statusCode].int != nil ? json[JsonCode.statusCode].int! : ResponseCode.serverError
            self.blockFailure!(status, "Something went wrong")
        }
    }
    
    private func validCode(code :Int!) -> Bool{
        if code == ResponseCode.success {
            return true
        }else {
            return false
        }
    }
    
    func genURL() -> String {
        let api :String = dataSource.api()
        let url :String = String.init(format: "%@/%@", NetworkConfig.API_URL, api)
        print("API requesting ", url)
        return url
    }
    
    func getDefaultHeaders() -> HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Accept" : "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }
}
