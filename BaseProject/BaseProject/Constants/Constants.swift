//
//  Constants.swift
//  BaseProject
//
//  Created by Manish on 11/09/17.
//  Copyright © 2017 Manish. All rights reserved.
//

import Foundation

// MARK: Validations Message during signup and sign in process
let kMessageFirstNameBlank = "Please enter your first name."
let kMessageLastNameBlank = "Please enter your last name."
let kMessageEmailBlank = "Please enter your email address."
let kMessagePasswordBlank = "Please enter your password."
let kMessageCurrentPasswordBlank = "Please enter your current password."
let kMessageProfileConfirmPasswordBlank = "Please confirm your password."
let kMessageConfirmPasswordBlank = "Please confirm the password."
let kMessagePasswordMatchingToOtherFields = "Your password should not match with email id"
let kMessageValidEmail = "Please enter valid email address."
let kMessageValidatePasswords = "The Password and Confirm password fields don't match."
let kMessageProfileValidatePasswords = "New password and confirm password fields don't match."
let kMessageValidatePasswordCharacters = "Password should have minimum of 8 characters."

let kSpecialCasesString = "lower case letter, upper case letter, numeric,  special characters "
let kSpecialCharactersString = "\\!  # $ % & ' () * + , - . : ; < > = ? @ [] ^ _  { } | ~"
let kMessagePasswordLength = "Your password must contain: 8 to 64 characters, "
let kMessageValidatePasswordComplexity = kMessagePasswordLength + kSpecialCasesString + kSpecialCharactersString
let kMessageAgreeToTermsAndConditions = "Please agree to terms and conditions."
let kMessageNewPasswordBlank = "Please enter your new password."
let kMessageValidateChangePassword = "New password and old password are same."
let kMessageAllFieldsAreEmpty = "Please enter all the fields"

// MARK: Settings Api Constants

let kSettingsRemoteNotifications = "remoteNotifications"
let kSettingsLocalNotifications = "localNotifications"
let kSettingsPassCode = "passcode"
let kSettingsTouchId = "touchId"
let kSettingsLeadTime = "reminderLeadTime"
let kSettingsLocale = "locale"
