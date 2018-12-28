//
//  RegistrationViewController.swift
//  BaseProject
//
//  Created by Manish on 06/09/17.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

enum TextFieldTags: Int {
    case emailId = 0
    case password
    case confirmPassword
}

class RegistrationViewController: UIViewController {

    // MARK: UIControls
    @IBOutlet weak var buttonRegister: UIButton!

    // MARK: Data Members
    var currentUser = User.currentUser

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

    // MARK: Button Actions

    /**
     *  Called when "Register/SignUp" button is tapped
     */

    @IBAction func registerButtonAction(sender: Any) {

        if self.validateAllFields() == true {

            //Call the Webservice for registration
        }
    }

    // MARK: Custom Methods

    /**
     
     All validation checks and Password,Email complexity checks
     
     @return Bool
     
     */

    /**
     *  Add all the validations on your values here
     */

    func validateAllFields() -> Bool {

        if  (self.currentUser.emailId?.isEmpty)! && (self.currentUser.password?.isEmpty)! {
            self.showAlertMessages(textMessage: kMessageAllFieldsAreEmpty)
            return false
        } else if self.currentUser.emailId == kEmptyString {
            self.showAlertMessages(textMessage: kMessageEmailBlank)
            return false
        } else if !(Utilities.isValidEmail(emailString: self.currentUser.emailId!)) {
            self.showAlertMessages(textMessage: kMessageValidEmail)
            return false
        } else if self.currentUser.password == kEmptyString {
            self.showAlertMessages(textMessage: kMessagePasswordBlank)
            return false
        } else if Utilities.isPasswordValid(text: (self.currentUser.password)!) == false {
            self.showAlertMessages(textMessage: kMessageValidatePasswordComplexity)
            return false
        } else if (self.currentUser.password)! == currentUser.emailId {
            self.showAlertMessages(textMessage: kMessagePasswordMatchingToOtherFields)
            return false
        }
        /* Uncomment this for the confirm password field
         
         else if confirmPassword == "" {
         self.showAlertMessages(textMessage: kMessageProfileConfirmPasswordBlank)
         return false
         }
         else if (self.user.password != confirmPassword){
         self.showAlertMessages(textMessage: kMessageValidatePasswords)
         return false
         }*/
        return true
    }

    /**
     *  Web Service Request for registration
     */

    func requestToRegister() {

        UserServices().registerUser(self)
    }

    /**
     *  After successful registration, update the user details in the User Model
     */
    func updateUserDetails() {
        currentUser.emailId = kEmptyString //replace kEmptyString with the new updated value
        currentUser.firstName = kEmptyString //replace kEmptyString with the new updated value
        currentUser.lastName = kEmptyString //replace kEmptyString with the new updated value
    }

    // MARK: Utility Methods
    /**
     
     Used to show the alert using Utility
     @param textMessage     data which we need to display in the alert
     
     */
    func showAlertMessages(textMessage: String) {
        UIUtilities.showAlertMessage(kEmptyString,
                                     errorMessage: NSLocalizedString(textMessage, comment: kEmptyString),
                                     errorAlertActionTitle: NSLocalizedString("OK", comment: kEmptyString),
                                     viewControllerUsed: self)
    }
}

// MARK: UITextFieldDelegate Methods
extension RegistrationViewController: UITextFieldDelegate {

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

        let tag: TextFieldTags = TextFieldTags(rawValue: textField.tag)!

        switch tag {

        case .emailId:
            self.currentUser.emailId = textField.text!
            break

        case .password:
            break

        case .confirmPassword:
            break
        }
    }
}

// MARK: WebService Delegate Methods
extension RegistrationViewController: NMWebServiceDelegate {

    func startedRequest(_ manager: NetworkManager, requestName: String) {

    }

    func finishedRequest(_ manager: NetworkManager, requestName: String, response: AnyObject?) {

    }

    func failedRequest(_ manager: NetworkManager, requestName: String, error: NSError) {

    }
}
