//
//  User.swift
//  BaseProject
//
//  Created by Manish on 07/09/17.
//  Copyright © 2017 Manish. All rights reserved.
//

import Foundation

//let kUserFirstName = "firstName"
//let kUserLastName = "lastName"
//let kUserEmailId = "emailId"
//let kUserId = "userId"
let kEmptyString = ""

class User {
    //Data Members
    //Note:- add/remove user details as per the requirement
    var firstName: String!
    var lastName: String!
    var emailId: String!
    var userId: String!
    var password: String!

    //make it singleton
    private static var _currentUser: User?

    static var currentUser: User {
        if _currentUser == nil { _currentUser = User() }
        return _currentUser!
    }

    /* Used to reset the user */
    static func resetCurrentUser() {
        _currentUser = nil
    }
    // MARK: Initializer Methods
    init() {
        self.firstName = ""
        self.lastName = ""
        self.emailId  = ""
        self.userId = ""
    }

    init(firstName: String?, lastName: String?, emailId: String?, userId: String?) {

        if Utilities.isValidValue(someObject: firstName as AnyObject) {
            self.firstName = firstName
        }

        if Utilities.isValidValue(someObject: lastName as AnyObject) {
            self.lastName = lastName
        }

        if Utilities.isValidValue(someObject: emailId as AnyObject) {
            self.emailId = emailId
        }

        if Utilities.isValidValue(someObject: userId as AnyObject) {
            self.userId = userId
        }
    }

    // MARK: Setter Methods
    func setUserDetails(details: [String: Any]) {

        if Utilities.isValidObject(someObject: details as AnyObject) {

            if Utilities.isValidValue(someObject: details[kUserFirstName] as AnyObject) {
                if let firstName = details[kUserFirstName] as? String {
                    self.firstName = firstName
                } else {
                    self.firstName = kEmptyString
                }
            }

            if Utilities.isValidValue(someObject: details[kUserLastName] as AnyObject) {
                if let lastName = details[kUserLastName] as? String {
                    self.lastName = lastName
                } else {
                    self.lastName = kEmptyString
                }
            }

            if Utilities.isValidValue(someObject: details[kUserEmailId] as AnyObject) {
                if let userEmail = details[kUserEmailId] as? String {
                    self.emailId = userEmail
                } else {
                    self.emailId = kEmptyString
                }
            }

            if Utilities.isValidValue(someObject: details[kUserId] as AnyObject) {
                if let userID = details[kUserId] as? String {
                    self.userId = userID
                } else {
                    self.userId = nil
                }
            }
        }
    }

    func setFirstName(firstName: String) {
        self.firstName = firstName
    }

    func setLastName(lastName: String) {
        self.lastName = lastName
    }

    func setEmailId(emailId: String) {
        self.emailId = emailId
    }

    func setUserId(userId: String) {
        self.userId = userId
    }

    // MARK: Getter Methods

    /**
     *  Used to get the full name of the user
     *  @return : String -> Full name of the user
     */
    func getFullName() -> String {
        return firstName + " " + lastName!
    }

    /**
     *  Used to get the email id of the user
     *  @return : String -> Email ID of the user
     */
    func getUserEmail() -> String? {
        return emailId!
    }

    /**
     *  Used to get the User id of the user
     *  @return : String -> User ID of the user
     */
    func getUserID() -> String? {
        return userId!
    }

    /**
     *  Used to get the all the details of the user
     *  @return : Dictionary -> containig all the details of the user
     *
     *  Note:- add/remove the details you want to get
     */

    func getUserDetails() -> [String: Any] {

        var userDetails = [String: Any].init()

        if self.firstName != nil {
            userDetails[kUserFirstName] = self.firstName
        } else {
            userDetails[kUserFirstName] = kEmptyString
        }

        if self.lastName != nil {
            userDetails[kUserLastName] = self.lastName
        } else {
            userDetails[kUserLastName] = kEmptyString
        }

        if self.userId != nil {
            userDetails[kUserId] = self.userId
        }
        return userDetails
    }
}

// MARK: User Settings
class Settings {

    var remoteNotifications: Bool?
    var localNotifications: Bool?

    init() {
        self.remoteNotifications = false
        self.localNotifications = true
    }

    init(remoteNotifications: Bool?, localNotifications: Bool?) {

        if Utilities.isValidValue(someObject: remoteNotifications as AnyObject) {
            self.remoteNotifications = remoteNotifications
        }

        if Utilities.isValidValue(someObject: localNotifications as AnyObject) {
            self.localNotifications = localNotifications
        }

    }

    func setRemoteNotification(value: Bool) {
        self.remoteNotifications = value
    }

    func setLocalNotification(value: Bool) {
        self.localNotifications = value
    }

    func setSettings(dict: [String: Any]) {

        if Utilities.isValidObject(someObject: dict as AnyObject) {

            if  Utilities.isValidValue(someObject: dict[kSettingsRemoteNotifications] as AnyObject) {
                self.remoteNotifications = dict[kSettingsRemoteNotifications] as? Bool
            }
            if Utilities.isValidValue(someObject: dict[kSettingsLocalNotifications] as AnyObject) {
                self.localNotifications = dict[kSettingsLocalNotifications] as? Bool
            }
        } else {
            Logger.sharedInstance.debug("Settings Dictionary is null:\(dict)")
        }
    }
}
