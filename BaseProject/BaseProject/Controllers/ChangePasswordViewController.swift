//
//  ChangePasswordViewController.swift
//  BaseProject
//
//  Created by Manish on 06/09/17.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

enum TextFieldType: Int {
    case oldPassword = 0
    case newPassword
    case confirmPassword
}

class ChangePasswordViewController: UIViewController {

    // MARK: UIControls
    @IBOutlet weak var changePasswordButton: UIButton!

    // MARK: Data Members
    var newPassword = kEmptyString
    var oldPassword = kEmptyString
    var confirmPassword = kEmptyString

    // MARK: ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Button Action

    /**
     
     Validations after clicking on submit button
     If all the validations satisfy send user feedback request
     
     @param sender accepts any object
     
     */

    /**
     *  Called when "Change Password" button is tapped
     */

    @IBAction func changePasswordButtonAction(sender : Any) {

        if self.validateAllFields() {
            //Call the web service to change the password
        }
    }

    // MARK: Custom Methods

    /**
     *  Add all the validations on your values here
     *  Show the appropriate error message as per the input field
     */

    func validateAllFields() -> Bool {

        if self.oldPassword.isEmpty && self.newPassword.isEmpty && self.confirmPassword.isEmpty {
            self.showAlertMessages(textMessage: kMessageAllFieldsAreEmpty)
            return false
        } else if self.oldPassword == kEmptyString {
            self.showAlertMessages(textMessage: kMessageCurrentPasswordBlank)
            return false
        } else if self.newPassword == kEmptyString {
            self.showAlertMessages(textMessage: kMessageNewPasswordBlank)
            return false
        } else if self.confirmPassword == kEmptyString {
            self.showAlertMessages(textMessage: kMessageProfileConfirmPasswordBlank)
            return false
        } else if Utilities.isPasswordValid(text: self.newPassword) == false {
            self.showAlertMessages(textMessage: kMessageValidatePasswordComplexity)
            return false
        } else if self.newPassword == User.currentUser.emailId {
            self.showAlertMessages(textMessage: kMessagePasswordMatchingToOtherFields)
            return false
        } else if self.newPassword != self.confirmPassword {
            self.showAlertMessages(textMessage: kMessageProfileValidatePasswords)
            return false
        } else {
            return true
        }
    }

    /**
     *  Web Service Request for ChangePassword
     */

    func requestToChangePassword() {
        UserServices().requestForChangePassword(self)
    }

    // MARK: Utility Methods
    /**
     
     Used to show the alert using Utility
     
     @param textMessage   used to display the text in the alert
     
     */
    func showAlertMessages(textMessage: String) {
        UIUtilities.showAlertMessage(kEmptyString,
                                     errorMessage: NSLocalizedString(textMessage,
                                     comment: kEmptyString),
                                     errorAlertActionTitle: NSLocalizedString("OK", comment: kEmptyString),
                                     viewControllerUsed: self)
    }
}

// MARK: UITextFieldDelegate Methods

extension ChangePasswordViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text =  textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let tag: TextFieldType = TextFieldType(rawValue : textField.tag)!

        switch tag {
        case .oldPassword:
            self.oldPassword = textField.text!
            break
        case .newPassword:
            self.newPassword = textField.text!
            break
        case .confirmPassword:
            self.confirmPassword = textField.text!
            break
        }
    }
}

// MARK: WebService Delegate Methods

extension ChangePasswordViewController: NMWebServiceDelegate {
    func startedRequest(_ manager: NetworkManager, requestName: String) {

    }

    func finishedRequest(_ manager: NetworkManager, requestName: String, response: AnyObject?) {

    }

    func failedRequest(_ manager: NetworkManager, requestName: String, error: NSError) {

    }
}
