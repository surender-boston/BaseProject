//
//  ForgotPasswordViewController.swift
//  BaseProject
//
//  Created by Manish on 06/09/17.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    // MARK: UIControls
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!

    // MARK: ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Button Actions
    /**
     *  Called when submit button is tapped
     */

    @IBAction func submitButtonAction(sender : Any) {

    }

    // MARK: Custom Methods
    /**
     *  Call the web service for "Forgot password" feature
     */

    func requestForNewPassword() {
        UserServices().requestForForgotPassword(self)
    }
}

// MARK: UITextFieldDelegate Methods
extension ForgotPasswordViewController : UITextFieldDelegate {

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
        textFieldEmail.text = textField.text!

    }
}

// MARK: WebService Delegate Methods
extension ForgotPasswordViewController: NMWebServiceDelegate {

    func startedRequest(_ manager: NetworkManager, requestName: String) {

    }

    func finishedRequest(_ manager: NetworkManager, requestName: String, response: AnyObject?) {

    }

    func failedRequest(_ manager: NetworkManager, requestName: String, error: NSError) {

    }
}
