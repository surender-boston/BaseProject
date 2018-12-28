//
//  ProfileViewController.swift
//  BaseProject
//
//  Created by Manish on 06/09/17.
//  Copyright © 2017 Manish. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: UIControls
    @IBOutlet weak var editProfileButton: UIButton!

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
     *  Called when "Update Profile" button is tapped
     */

    @IBAction func updateProfileButtonAction(sender : Any) {

    }

    // MARK: Custom Methods

    /**
     *  Validate all the input values before calling the web service for profile update
     */

    func validateAllValues() {

    }

    /**
     *  After updating profile successfully, update the user details in the User Model
     */

    func updateUserDetails() {

        currentUser.emailId = kEmptyString //replace kEmptyString with the new updated value
        currentUser.firstName = kEmptyString //replace kEmptyString with the new updated value
        currentUser.lastName = kEmptyString //replace kEmptyString with the new updated value
    }

    /**
     *  Web Service Request for Update Profile
     */

    func requestToUpdateProfile() {

        UserServices().requestForUpdateProfile(self)
    }

}

// MARK: UITextFieldDelegate Methods
extension ProfileViewController : UITextFieldDelegate {

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
extension ProfileViewController: NMWebServiceDelegate {

    func startedRequest(_ manager: NetworkManager, requestName: String) {

    }

    func finishedRequest(_ manager: NetworkManager, requestName: String, response: AnyObject?) {

    }

    func failedRequest(_ manager: NetworkManager, requestName: String, error: NSError) {

    }
}
