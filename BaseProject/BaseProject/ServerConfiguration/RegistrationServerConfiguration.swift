//
//  RegistrationConfiguration.swift
//  NetworkModule
//
//  Created by Srujan on 07/09/17.
//  Copyright © 2017 BTC. All rights reserved.
//

import UIKit
enum RegistrationMethods: String {
    // Write exact name for request method
    case login
    case register
    case forgotPassword
    case changePassword
    case getProfile
    case updateProfile
    case logout
    var description: String {
        switch self {
        default:
            return self.rawValue+".api"
        }
    }
    var method: Method {
        switch self {
        case .login:
            //GET Methods
            return Method(methodName:(self.rawValue+".api"), methodType: .httpMethodGet, requestType: .requestTypeHTTP)
        case .register:
            //DELETE Methods
            return Method(methodName:(self.rawValue+".api"), methodType: .httpMethodPOST, requestType: .requestTypeJSON)
        default:
            //POST Methods
            return Method(methodName:(self.rawValue+".api"), methodType: .httpMethodDELETE, requestType: .requestTypeJSON)
        }
    }
}
struct RegistrationServerURLConstants {
    // Set the server end points
    static let ProductionURL = ""
    static let DevelopmentURL = ""
}
class RegistrationServerConfiguration: NetworkConfiguration {
    static let configuration = RegistrationServerConfiguration()
    // MARK: Delegates
    override func getProductionURL() -> String {
        return RegistrationServerURLConstants.ProductionURL
    }
    override func getDevelopmentURL() -> String {
        return RegistrationServerURLConstants.DevelopmentURL
    }
    override func getDefaultHeaders() -> [String : String] {
        return Dictionary()
    }
    override func getDefaultRequestParameters() -> [String : Any] {
        return Dictionary()
    }
    override func shouldParseErrorMessage() -> Bool {
        return false
    }
}
