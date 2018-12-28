//
//  NetworkConstants.swift
//  NetworkModule
//
//  Created by Srujan on 07/09/17.
//  Copyright © 2017 BTC. All rights reserved.
//

import Foundation
private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// MARK: WebRequestMethods

struct NetworkConnectionConstants {
    static let ConnectionTimeoutInterval = 30.0
    static let NoOfRequestRetry  = 3
    static let EnableRequestRetry = false
}

struct TrustedHosts {
    static let TrustedHost1 = ""
    static let TrustedHost2 = ""
    static let TrustedHost3 = ""
}

struct HTTPHeaderKeys {
    static let SetCookie = "Set-Cookie"
    static let ContentType = "Content-Type"
}

struct HTTPHeaderValues {
    static  let ContentTypeJson = "application/json"
}

struct NetworkURLConstants {
    // Set the server end points
    static let ProductionURL = ""
    static let DevelopmentURL = ""
}

class NetworkConstants: NSObject {
    // Configure common parameters for requests here.
    class func getCommonRequestParameters()-> [String:Any]? {
        return nil
    }
    class func getCommonHeaderParameters() -> [String:Any]? {
        _ = UserDefaults.standard.value(forKey: "cookies")
        let headers: [String:String]? =  nil
        /*
        if (cookie != nil && (cookie as AnyObject).length > 0){
            headers = ["cookie" : cookie!]
        }
        */
        return headers
    }
    fileprivate func getTrustedHosts() -> [String] {
        let array = [TrustedHosts.TrustedHost1, TrustedHosts.TrustedHost2, TrustedHosts.TrustedHost3]
        return array as Array
    }
    class func checkResponseHeaders(_ response: URLResponse) -> (NSInteger, String) {
        let httpResponse = response as? HTTPURLResponse
        let headers = httpResponse!.allHeaderFields as? [String:Any]
        let statusCode = httpResponse!.statusCode
        var statusMessage = ""
        if let message = headers!["StatusMessage"] {
            // now val is not nil and the Optional has been unwrapped, so use it
            statusMessage = (message as? String)!
        }
        return (statusCode, statusMessage)
    }
}
