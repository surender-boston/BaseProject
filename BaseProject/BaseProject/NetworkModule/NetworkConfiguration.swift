//
//  NetworkConfiguration.swift
//  NetworkModule
//
//  Created by Srujan on 07/09/17.
//  Copyright © 2017 BTC. All rights reserved.
//

import Foundation

protocol NetworkConfigurationProtocol {
    /**
     *  Called to get development URL
     *
     *  @return URL in String fromat
     */
    func getDevelopmentURL() -> String
    /**
     *  Called to get production URL
     *
     *  @return URL in String fromat
     */
    func getProductionURL() -> String
    /**
     *  Called to get defaultHeaders
     *
     *  @return Dictionary
     */
    func getDefaultHeaders() -> [String:String]
    /**
     *  Called to get defaultRequestParameters
     *
     *  @return Dictionary
     */
    func getDefaultRequestParameters() -> [String:Any]
}
class  Method {
    let methodName: String
    let methodType: HTTPMethod
    let requestType: RequestType
    init(methodName: String, methodType: HTTPMethod, requestType: RequestType) {
        self.methodName = methodName
        self.methodType = methodType
        self.requestType = requestType
    }
}
class NetworkProtocols: NetworkConfigurationProtocol {
    internal func getDefaultRequestParameters() -> [String:Any] {
        return Dictionary()
    }

    internal func getDefaultHeaders() -> [String:String] {
        return Dictionary()
    }

    internal func getProductionURL() -> String {
        return ""
    }

    internal func getDevelopmentURL() -> String {
        return ""
    }
    internal func shouldParseErrorMessage() -> Bool {
        return false
    }
    internal func parseError(errorResponse: [String:Any]) -> NSError {
        // Handle your error here
        let error = NSError(domain: NSURLErrorDomain, code: 101, userInfo: [NSLocalizedDescriptionKey: "Your error localized description"])
        return  error
    }
}
class NetworkConfiguration: NetworkProtocols {
}
