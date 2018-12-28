//
//  UIUtilities.swift
//  Utilities
//
//  Created by Reddanna on 04/08/16.
//  Copyright © 2016 BTC. All rights reserved.
//

import Foundation
import UIKit

public typealias AlertAction = () -> Void

class UIUtilities: NSObject {
    /* Presents alert message */
    class func showAlertWithTitleAndMessage(title: String, message: String) {

        let alert = UIAlertController(title:title,
                                      message:message,
                                      preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: ""),
                                      style: .default,
                                      handler: nil))

        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)

    }

    /* Presents alert message */
    class func showAlertWithMessage(alertMessage: String) {
        self.showAlertWithTitleAndMessage(title:"", message: alertMessage)
    }

    /* Initial Padding space before displaying the texts */
    class func paddingViewForTextFiled(textFiled: UITextField) {
        let paddingView =  UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: textFiled.frame.height))
        textFiled.leftView = paddingView
        textFiled.leftViewMode = UITextFieldViewMode.always
    }

    /**
     *   Add a border to Textfield
     *   @params:- textfield - the data which is used to show
     *   @return:- textfield - returns text field with padding space
     */

    class func addingBorderToTextField(textField: UITextField,
                                       borderColorString: String,
                                       backgroundColorString: String,
                                       borderWidth: CGFloat) -> UITextField {
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = Utilities.hexStringToUIColor(borderColorString).cgColor
        textField.backgroundColor =  Utilities.hexStringToUIColor(backgroundColorString)
        return textField
}

    /**
     *   Used to show invalid input for the particular textfield
     */

    class func getTextfieldWithInvalidInputBorder(textField: UITextField,
                                                  layerBorderColor: String,
                                                  backgroundColor: String,
                                                  borderWidth: CGFloat) {

        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = Utilities.hexStringToUIColor(layerBorderColor).cgColor
        textField.backgroundColor =  Utilities.hexStringToUIColor(backgroundColor)
    }

    /**
     *   Used to remove border from text field
     */

    class func removeTheBorderToTextField(textField: UITextField) -> UITextField {

        textField.borderStyle =  UITextBorderStyle.none
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.backgroundColor =  Utilities.hexStringToUIColor("556085")
        return textField
    }

    /**
     *   Used to set separator color of UISegmentControl
     */

    class func segmentSeparatorColor(color: UIColor, segment: UISegmentedControl) -> UIImage {

        // let rect = CGRectMake(0.0, 0.0, 1.5, segment.frame.size.height)
        let rect =  CGRect(x: 0.0, y: 0.0, width: 1.5, height: segment.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!

    }

    /**
     *   Used to apply blurr effect
     *   @return Blurred View
     */

    class func applyBlurrEffect() -> UIVisualEffectView {

        let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        visualEffect.tag = 100
        visualEffect.alpha = 1
        visualEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return visualEffect
    }

    /**
     *   Used to remove blurr effect added before
     *   @param UIView on which blurr is applied
     */

    class func removeBlur(fromView: UIView, withTag tag: Int) {
        for subView in fromView.subviews {
            if (subView.tag) == tag {
                subView.removeFromSuperview()
            }
        }
    }

    /**
     *   Performs spinning action using CoreAnimation
     */

    class func addSpinAnimation(withDuration duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 360
        animation.duration = duration
        return animation
    }

    class  func getHexColors() -> [Any] {

        let hexColors = ["ff9f30", "fdf22f", "b6ff14", "07f51c"]
        return hexColors
    }

    /**
     *   Used to add a faded view
     *   @param UIView on which effect has to be applied
     */

    class  func addFadedGreenView(view: UIView, colorString: String, alpha: CGFloat) -> UIView {

        let greenView = UIView.init(frame:view.frame)
        greenView.backgroundColor = Utilities.hexStringToUIColor(colorString)
        greenView.alpha = alpha
        view.addSubview(greenView)
        return greenView
    }

    /**
     *   Used to add a colored border on view
     *   @param  takes a view on which border has to be added,
     *           width of the border,
     *           corner radius and
     *           border color
     */

    class func setBorderColorOnView(view: UIView, borderWidth: CGFloat, cornerRadius: CGFloat, borderColor: UIColor) {

        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor.cgColor
    }

    /**
     *   Used to add a red colored border on view,
     *   usually in case of wrong text field entries
     *   @param   takes a view on which border has to be added,
     *            width of the border,
     *            corner radius
     *            string value for color
     */

    class func setRedBorderOnView(view: UIView, borderWidth: CGFloat, cornerRadius: CGFloat, colorString: String) {

        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = Utilities.hexStringToUIColor(colorString).cgColor
    }

    /**
     *   Used to convert dictionary into String
     *   @param Dictionary
     */

    class func convertDictionaryIntoString(mutableDic: [String: Any]) -> String {

        var jsonString: String!
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: mutableDic,
                                                            options: JSONSerialization.WritingOptions.prettyPrinted) as Data
            jsonString = String.init(data: jsonData, encoding: .utf8)
        } catch {

        }
        return jsonString
    }

    /**
     *   Used to convert Array into String
     *   @param Array
     */

    class func convertArrayIntoString(mutableArray: [Any]) -> String {

        var socialMediaNamesString: String!
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: mutableArray,
                                                            options: JSONSerialization.WritingOptions.prettyPrinted) as Data
            socialMediaNamesString = String.init(data: jsonData, encoding: .utf8)
        } catch {

        }
        return socialMediaNamesString
    }

    // MARK: Methods to show alert messages

    /**
     *   Used to show alert message having two actions
     *   @param  title for the alert,
     *           message for the alert,
     *           titles for the actions,
     *           controller on which alert has to be shown
     *           actions to be performed
     */

    class func showAlertMessageWithTwoActionsAndHandler(_ errorTitle: String,
                                                        errorMessage: String,
                                                        errorAlertActionTitle: String,
                                                        errorAlertActionTitle2: String?,
                                                        viewControllerUsed: UIViewController,
                                                        action1: @escaping AlertAction,
                                                        action2: @escaping AlertAction) {

        let alert = UIAlertController(title: errorTitle,
                                      message: errorMessage,
                                      preferredStyle:UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: errorAlertActionTitle,
                                      style: UIAlertActionStyle.default,
                                      handler: { (_) in
            action1()
        }))
        if errorAlertActionTitle2 != nil {
            alert.addAction(UIAlertAction(title: errorAlertActionTitle2,
                                          style: UIAlertActionStyle.default,
                                          handler: { (_) in
                action2()
            }))
        }
        viewControllerUsed.present(alert, animated:true, completion: nil)
    }

    /**
     *   Used to show alert message having one action
     *   @param  title for the alert,
     *           message for the alert,
     *           title for the action,
     *           controller on which alert has to be shown
     *           action to be performed
     */

    class func showAlertMessageWithActionHandler(_ title: String,
                                                 message: String,
                                                 buttonTitle: String,
                                                 viewControllerUsed: UIViewController,
                                                 action: @escaping AlertAction) {

        let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: buttonTitle,
                                      style: UIAlertActionStyle.default,
                                      handler: { (_) in
            action()
        }))
        viewControllerUsed.present(alert, animated:true, completion: nil)
    }

    /**
     *   Used to show alert message having one action
     *   @param  title for the alert,
     *           message for the alert,
     *           title for the action,
     *           controller on which alert has to be shown
     */

    class func showAlertMessage(_ errorTitle: String, errorMessage: String,
                                errorAlertActionTitle: String,
                                viewControllerUsed: UIViewController?) {

        let alert = UIAlertController(title: errorTitle,
                                      message: errorMessage,
                                      preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: errorAlertActionTitle, style: UIAlertActionStyle.default, handler: nil))
        viewControllerUsed!.present(alert, animated:true, completion: nil)
    }

}
