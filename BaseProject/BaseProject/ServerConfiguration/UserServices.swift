//
//  UserServices.swift
//  NetworkModule Demo
//
//  Created by Srujan on 07/09/17.
//  Copyright © 2017 BTC. All rights reserved.
//

import UIKit

// MARK: Registration Server API Constants
let kUserId = "userId"
let kUserEmailId = "emailId"
let kUserPassword = "password"
let kUserFirstName = "firstName"
let kUserLastName = "lastName"

// MARK: Your Keys
let kEmailId = "test3@grr.la"//"abc@gmail.com"
let kPassword = "Password@1"//"Password@123"
let kFirstName = "Boston"
let kLastName = "Technologies"

class UserServices: NSObject {

    let networkManager = NetworkManager.sharedInstance()
    weak var delegate: NMWebServiceDelegate! = nil
    var requestParams: [String:Any]? = [:]
    var headerParams: [String:String]? = [:]

    // MARK: Requests
    func loginUser(_ delegate: NMWebServiceDelegate) {
        self.delegate = delegate
        let params = [kUserEmailId: kEmailId,
                      kUserPassword: kPassword]
        let method = RegistrationMethods.login.method
        self.sendRequestWith(method:method, params: params, headers: nil)
    }

    func registerUser(_ delegate: NMWebServiceDelegate) {

        self.delegate = delegate

        let params = [kUserFirstName: kFirstName,
                      kUserLastName: kLastName,
                      kUserEmailId: kEmailId,
                      kUserPassword: kPassword]

        let method = RegistrationMethods.register.method
        self.sendRequestWith(method:method, params: params, headers: nil)
    }

    func requestForForgotPassword(_ delegate: NMWebServiceDelegate) {

        self.delegate = delegate
        let params = [kUserEmailId: kEmailId]
        let method = RegistrationMethods.forgotPassword.method
        self.sendRequestWith(method:method, params: params, headers: nil)

    }

    func requestForChangePassword(_ delegate: NMWebServiceDelegate) {

        self.delegate = delegate
        let params = [kUserEmailId: kEmailId]
        let method = RegistrationMethods.changePassword.method
        self.sendRequestWith(method:method, params: params, headers: nil)

    }

    func requestForUpdateProfile(_ delegate: NMWebServiceDelegate) {

        self.delegate = delegate
        let params = [kUserFirstName: kFirstName,
                      kUserLastName: kLastName,
                      kUserEmailId: kEmailId,
                      kUserPassword: kPassword]

        let method = RegistrationMethods.updateProfile.method
        self.sendRequestWith(method:method, params: params, headers: nil)

    }

    // MARK: Parsers

    func handleUserLoginResponse(response: [String:Any]) {
        // Parse the User Details
    }

    /**
     *  creating a request
     *  @param method  Web request method name
     *  @param params  request parameters in dictionary format
     *  @param params  header parameters in dictionary format
     *
     *  @return Dictionary
     */

    private func sendRequestWith(method: Method, params: [String:Any]?, headers: [String:String]?) {
        self.requestParams = params
        self.headerParams = headers
        networkManager.composeRequest(RegistrationServerConfiguration.configuration,
                                      method: method,
                                      params: params,
                                      headers: headers,
                                      delegate: self)
    }
}
extension UserServices: NMWebServiceDelegate {

    func startedRequest(_ manager: NetworkManager, requestName: String) {
        if delegate != nil {
            delegate.startedRequest(manager, requestName: requestName)
        }
    }

    func finishedRequest(_ manager: NetworkManager, requestName: String, response: AnyObject?) {

        switch requestName {
        case RegistrationMethods.login.description:
            self.handleUserLoginResponse(response: (response as? [String : Any])!)
        default : break
        }
        if delegate != nil {
            delegate.finishedRequest(manager, requestName: requestName, response: response)
        }
    }

    func failedRequest(_ manager: NetworkManager, requestName: String, error: NSError) {
        if delegate != nil {
            delegate.failedRequest(manager, requestName: requestName, error: error)
        }
    }
}
