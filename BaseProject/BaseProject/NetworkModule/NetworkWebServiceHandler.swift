//
//  NetworkWebServiceHandler.swift
//  NetworkModule
//
//  Created by Srujan on 07/09/17.
//  Copyright © 2017 BTC. All rights reserved.
//

import Foundation

let noNetworkErrorCode = -101
let serverErrorMessage = "Could not connect to server. Please try again later."
let offlineErrorMessage = "You seem to be offline. Please connect to a network to proceed with this action."

enum RequestType: NSInteger {
    case requestTypeJSON
    case requestTypeHTTP
}

enum HTTPMethod: NSInteger {
    case httpMethodGet
    case httpMethodPUT
    case httpMethodPOST
    case httpMethodDELETE
}

struct DefaultHeaders {
    static let DefaultHeaderKey: [String:Any] = ["\(HTTPHeaderKeys.ContentType)": (HTTPHeaderValues.ContentTypeJson)]
}

class NetworkWebServiceHandler: NSObject, URLSessionDelegate {
    var shouldRetryRequest = NetworkConnectionConstants.EnableRequestRetry
    var maxRequestRetryCount = NetworkConnectionConstants.NoOfRequestRetry
    var connectionTimeoutInterval: Double = NetworkConnectionConstants.ConnectionTimeoutInterval
    weak var delegate: NMWebServiceDelegate?
    weak var challengeDelegate: NMAuthChallengeDelegate?
    weak var networkManager: NetworkManager?
    var configuration: NetworkConfiguration!
    init(delegate: NMWebServiceDelegate, challengeDelegate: NMAuthChallengeDelegate?) {
        self.delegate = delegate
        self.challengeDelegate = challengeDelegate
    }
    func getServerURLString() -> String {
        #if DEBUG
            return self.configuration.getDevelopmentURL() as String
        #else
            return self.configuration.getProductionURL() as String
        #endif
    }
    fileprivate func getBaseURLString(_ requestName: String) -> String {
        return String.init(format: "%@%@", self .getServerURLString(), requestName)
    }
    fileprivate func getCombinedWithCommonParams(_ params: [String:Any]?) -> [String:Any]? {
         let commonParams  = self.configuration.getDefaultRequestParameters() as [String:Any]?
         var mParams: [String:Any]? = nil
         if commonParams != nil {
            mParams = commonParams
         }
         if  params != nil {
            if mParams != nil {
                for (key, value) in params! {
                        mParams?[String(describing: key)] = value
                }
         } else {
                mParams = params
         }
         }
         return mParams!
    }
    fileprivate func getCombinedHeaders(_ userHeaders: [String:Any]?, defaultHeaders: [String:Any]?) -> [String:Any]? {
        let commonParams = self.configuration.getDefaultHeaders() as [String:Any]?
        var mParams: [String:Any]? = nil
        if commonParams != nil {
            mParams = commonParams
        }
        if  defaultHeaders != nil {
            if mParams != nil {
                for (key, value) in defaultHeaders! {
                    mParams?[String(describing: key)] = value
                }
            } else {
                mParams = defaultHeaders
            }
        }
        if userHeaders != nil && userHeaders!.count > 0 {
            if mParams != nil {
                for (key, value) in userHeaders! {
                    mParams?[String(describing: key)] = value
                }
            } else {
                mParams = userHeaders
            }
        }
        return mParams!
    }
    func getRequestMethod(_ methods: HTTPMethod) -> String {
        switch methods {
        case .httpMethodGet:
            return "GET"
        case .httpMethodPOST:
            return "POST"
        case .httpMethodPUT:
            return "PUT"
        case .httpMethodDELETE:
            return "DELETE"
        }
    }
    fileprivate func getHttpRequest(_ requestName: String, parameters: [String:Any]?) -> String {
        var url: String = ""
        if !(parameters == nil || parameters?.count == 0) {
            let allKeys = parameters?.keys
            for key in allKeys! {
                url = (url as String) + String(format: "%@=%@&", String(describing: key), (parameters?[key ] as? CVarArg)! )
            }
            let length = url.characters.count-1
            let index = url.index(url.startIndex, offsetBy: length)
            url = url.substring(to: index)
        }
        return url as String
    }
    func composeRequestFor(_ requestName: String, requestType: RequestType, method: HTTPMethod, params: [String:Any]?, headers: [String:String]?) {
        if (delegate?.startedRequest) != nil {
            delegate?.startedRequest(networkManager!, requestName: requestName)
        }
        var requestParams: [String:Any]? = nil
        if params != nil {
            requestParams = self.getCombinedWithCommonParams(params!)
        }
        switch requestType {
        case .requestTypeHTTP:
            self.generateHTTPRequest(requestName, method: method, params: requestParams, headers: headers!)
            break
        case .requestTypeJSON:
            self.generateJSONRequest(requestName, method: method, params: requestParams, headers: headers)
            break
        }
    }
    func composeRequest(_ configuration: NetworkConfiguration, method: Method, params: [String:Any]?, headers: [String:String]?) {
        self.configuration = configuration
        if (delegate?.startedRequest) != nil {
            delegate?.startedRequest(networkManager!, requestName: method.methodName as String)
        }
        var requestParams: [String:Any]? = nil
        if params != nil {
            requestParams = self.getCombinedWithCommonParams(params)
        }
        switch method.requestType {
        case .requestTypeHTTP:
            self.generateHTTPRequest(method.methodName as String, method: method.methodType, params: requestParams, headers: headers)
            break
        case .requestTypeJSON:
            self.generateJSONRequest(method.methodName as String, method: method.methodType, params: requestParams, headers: headers)
            break
        }
    }
    fileprivate func generateHTTPRequest(_ requestName: String, method: HTTPMethod, params: [String:Any]?, headers: [String:String]?) {
        let httpHeaders: [String:Any]? = self.getCombinedHeaders(headers, defaultHeaders: nil)
        let baseURLString: String = self.getBaseURLString(requestName)
        let httpRequestString: String? = self.getHttpRequest(requestName, parameters: params)
        var requestString: String!
        if httpRequestString?.characters.count == 0 {
            requestString = baseURLString
        } else {
            requestString = String(format:"%@?%@", baseURLString, httpRequestString!) as String!
        }
        if #available(iOS 9, *) {
            requestString = requestString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) as String!
        } else {
            requestString = requestString.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as String!
        }
        let requestUrl = URL(string: requestString as String)!
         var request = URLRequest.init(url: requestUrl, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: self.connectionTimeoutInterval)
        request.httpMethod = self.getRequestMethod(method) as String
        if httpHeaders != nil && (httpHeaders?.count)! > 0 {
            request.allHTTPHeaderFields = httpHeaders as? [String : String]
        }
        self.fireRequest(request, requestName: requestName)
    }
    fileprivate func generateJSONRequest(_ requestName: String, method: HTTPMethod, params: [String:Any]?, headers: [String:String]?) {
        var defaultheaders: [String:Any]? = DefaultHeaders.DefaultHeaderKey
        if params == nil || params?.count == 0 {
            defaultheaders = nil
        }
        let httpHeaders: [String:Any]? = self.getCombinedHeaders(headers, defaultHeaders: defaultheaders)
        let baseURLString: String = self.getBaseURLString(requestName)
        let requestUrl = URL(string: baseURLString as String)
        do {
            var request = URLRequest.init(url: requestUrl!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: self.connectionTimeoutInterval)
            if params != nil && (params?.count)! > 0 {
                let data = try JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
            }
            request.httpMethod=self.getRequestMethod(method) as String
            if httpHeaders != nil {
                request.allHTTPHeaderFields = httpHeaders! as? [String : String]
            }
            self.fireRequest(request, requestName: requestName)
        } catch {
            print("Serilization error")
        }
    }
    fileprivate func fireRequest (_ request: URLRequest?, requestName: String?) {
        if NetworkManager.isNetworkAvailable() {
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession.init(configuration: config, delegate: self, delegateQueue: nil)
            session.dataTask(with: request!) {(data, response, error) -> Void in
                if let data = data {
                    DispatchQueue.main.async {
                        self.handleResponse(data, response: response, requestName: requestName, error: error as NSError?)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.failedRequest(self.networkManager!, requestName: requestName!, error: error! as NSError)
                    }
                }
                }.resume()
        } else {
            if (delegate?.failedRequest) != nil {
                let error1 = NSError(domain: NSURLErrorDomain, code: noNetworkErrorCode, userInfo: [NSLocalizedDescriptionKey: offlineErrorMessage])
                delegate?.failedRequest(networkManager!, requestName: requestName!, error: error1)
            }
        }
    }
    func handleResponse(_ data: Data?, response: URLResponse?, requestName: String?, error: NSError?) {
        if error != nil {
            if shouldRetryRequest && maxRequestRetryCount > 0 {
                maxRequestRetryCount -= 1
            } else {
                if error?.code == -1001 { //Could not connect to the server.
                }
                if (delegate?.failedRequest) != nil {
                    delegate?.failedRequest(networkManager!, requestName: requestName!, error: error!)
                }
            }
        } else {
            let status = NetworkConstants.checkResponseHeaders(response!)
            let statusCode = status.0
            var error1: NSError?
            if statusCode == 200 || statusCode == 0 {
                var responseDict: [String:Any]? = nil
                do {
                    //NSJSONReadingOptions.MutableContainers
                    responseDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                } catch {
                    print("Serilization error")
                }
                if (delegate?.finishedRequest) != nil {
                    if responseDict != nil {
                        delegate?.finishedRequest(networkManager!, requestName: requestName!, response: responseDict! as AnyObject)
                    } else {
                        var dictionary = [String: Any]()
                        if let httpResponse = response as? HTTPURLResponse {
                            if let contentType = httpResponse.allHeaderFields["Status Message"] as? String {
                                // use contentType here
                                dictionary = ["Status Message": contentType]
                            }
                        }
                        error1 = NSError(domain: NSURLErrorDomain, code: 300, userInfo:[NSLocalizedDescriptionKey: serverErrorMessage])
                        if (delegate?.failedRequest) != nil {
                            delegate?.failedRequest(networkManager!, requestName: requestName!, error:error1!)
                        }
                    }
                }
            } else {
                if self.configuration.shouldParseErrorMessage() {
                    var responseDict: [String:Any]? = nil
                    do {
                      responseDict = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String:Any]
                    } catch {
                        print("Serilization error")
                    }
                    error1 = self.configuration.parseError(errorResponse: responseDict!)
                } else {
                    error1 = NSError(domain: NSURLErrorDomain, code:statusCode, userInfo:[NSLocalizedDescriptionKey: status.1])
                }
                if (delegate?.failedRequest) != nil {
                    delegate?.failedRequest(networkManager!, requestName: requestName!, error:error1!)
                }
            }
        }
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var credential: URLCredential!
        if (challengeDelegate?.networkCredential) != nil {
            credential = challengeDelegate?.networkCredential(networkManager!, challenge: challenge)
        }
        if credential != nil {
            var challengeDisposition: Foundation.URLSession.AuthChallengeDisposition!
            if (challengeDelegate?.networkChallengeDisposition) != nil {
                challengeDisposition = challengeDelegate?.networkChallengeDisposition(networkManager!, challenge: challenge)
            }
            completionHandler(challengeDisposition, credential)
        }
    }
}
