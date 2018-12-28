//
//  LoginViewController.swift
//  BaseProject
//
//  Created by Manish on 06/09/17.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

enum LogInTextFieldTags: Int {
    case email = 0
    case paswword
}

class LoginViewController: UIViewController {

    // MARK: UIControls
    @IBOutlet weak var buttonLoginWithEmail: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var buttonForgotPassword: UIButton!

    // MARK: Data Members
    var currentUser = User.currentUser
    
    // MARK: ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        requestToLogin()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Button Actions
    /**
     *  Called when "Login" button is tapped
     */

    @IBAction func loginWithEmailButtonAction(sender: Any) {

    }
    /**
     *  Called when "Forgot Password" button is tapped
     */
    @IBAction func forgotPasswordButtonAction(sender: Any) {

    }
    /**
     *  Called when "Register/SignUp" button is tapped
     */
    @IBAction func registerButtonAction(sender: Any) {

    }
    // MARK: Custom Methods
    /**
     *  Web Service Request for login
     */
    func requestToLogin() {
        UserServices().loginUser(self)
    }
    /**
     *  After successful login, update the user details in the User Model
     */
    func updateUserDetails() {
        currentUser.emailId = kEmptyString //replace kEmptyString with the new updated value
        currentUser.firstName = kEmptyString //replace kEmptyString with the new updated value
        currentUser.lastName = kEmptyString //replace kEmptyString with the new updated value
    }
}
// MARK: UITextField Delegate Methods
extension LoginViewController: UITextFieldDelegate {

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
    }
}

// MARK: WebService Delegate Methods
extension LoginViewController: NMWebServiceDelegate {

    func startedRequest(_ manager: NetworkManager, requestName: String) {

    }

    func finishedRequest(_ manager: NetworkManager, requestName: String, response: AnyObject?) {
        print(response ?? "")
    }

    func failedRequest(_ manager: NetworkManager, requestName: String, error: NSError) {
        print(error.localizedDescription)
    }
}
