//
//  NetworkManager.swift
//  NetworkModule
//
//  Created by Srujan on 07/09/17.
//  Copyright © 2017 BTC. All rights reserved.
//

import Foundation
import UIKit

protocol NMWebServiceDelegate: class {
    /**
     *  Called when request is fired.Use this to show any activity indicator
     *
     *  @param manager       NetworkManager instance
     *  @param requestName Web request@objc  name
     */
    func startedRequest(_ manager: NetworkManager, requestName: String)
    /**
     *  Called when request if finished. Handle your response or error in this delegate
     *
     *  @param manager       NetworkManager instance
     *  @param requestName Web request name
     *  @param response    Web response of Dictionary format
     */
    func finishedRequest(_ manager: NetworkManager, requestName: String, response: AnyObject?)
    /**
     *  Called when request failed, Handle errors in this delegate
     *
     *  @param manager       NetworkManager instance
     *  @param requestName Web request name
     *  @param error       Request error
     */
    func failedRequest(_ manager: NetworkManager, requestName: String, error: NSError)
}

protocol NMAuthChallengeDelegate: class {
    /**
     *  Called when server throws for authentacation challenge
     *
     *  @param manager     NetworkManager instance
     *  @param challenge NSURLAuthenticationChallenge
     *
     *  @return NSURLCredential
     */
    func networkCredential(_ manager: NetworkManager, challenge: URLAuthenticationChallenge) -> URLCredential
    /**
     *  Called when request ask for authentication
     *
     *  @param manager     NetworkManager instance
     *  @param challange NSURLAuthenticationChallenge
     *
     *  @return NSURLSessionAuthChallengeDisposition
     */
    func networkChallengeDisposition(_ manager: NetworkManager, challenge: URLAuthenticationChallenge) -> URLSession.AuthChallengeDisposition
}

class NetworkManager {
    static var instance: NetworkManager?
    var networkAvailability: Bool = true
    var reachability: Reachability?
    class func isNetworkAvailable() -> Bool {
        return self.sharedInstance().networkAvailability
    }
    init() {
//        do {
//            reachability =  Reachability.init()
//        } catch {
//            print("Unable to create Reachability")
//        }
        reachability =  Reachability.init()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name:reachabilityChangedNotification, object: nil)
        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    class func sharedInstance() -> NetworkManager {
        self.instance = self.instance ?? NetworkManager()
        return self.instance!
    }
    @objc func reachabilityChanged(_ notification: Notification) {
        if self.reachability!.isReachable {
            networkAvailability = true
        } else {
            networkAvailability = false
        }
    }
    /**
     *  Request compose with requestName and requestType
     *
     *  @param requestName Web request name
     *  @param requestType Web request type
     *  @param method      HTTPMethod type
     *  @param params      request parameters in dictionary format
     *  @param params      header parameters in dictionary format
     *  @param delegate    NMWebServiceDelegate
     *
     */
    func composeRequest(_ requestName: String, requestType: RequestType, method: HTTPMethod, params: [String:Any]?, headers: [String:String]?, delegate: NMWebServiceDelegate) {
        let networkWSHandler = NetworkWebServiceHandler(delegate: delegate, challengeDelegate: UIApplication.shared.delegate as? NMAuthChallengeDelegate)
        networkWSHandler.networkManager = self
        networkWSHandler.composeRequestFor(requestName, requestType: requestType, method: method, params: params, headers: headers)
    }
    /**
     *  Request compose with NetworkConfiguration
     *
     *  @param configuration NetworkConfiguration
     *  @param method        Web request method name
     *  @param params        request parameters in dictionary format
     *  @param params        header parameters in dictionary format
     *  @param delegate      NMWebServiceDelegate
     *
     */
    func composeRequest(_ configuration: NetworkConfiguration, method: Method, params: [String:Any]?, headers: [String:String]?, delegate: NMWebServiceDelegate) {
        let networkWSHandler = NetworkWebServiceHandler(delegate: delegate, challengeDelegate: UIApplication.shared.delegate as? NMAuthChallengeDelegate)
        networkWSHandler.networkManager = self
        networkWSHandler.composeRequest(configuration, method: method, params: params, headers: headers)
    }
}
