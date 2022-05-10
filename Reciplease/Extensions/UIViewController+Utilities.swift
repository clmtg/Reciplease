//
//  UIViewController+Utilities.swift
//  Reciplease
//
//  Created by Clément Garcia on 21/04/2022.
//

import Foundation
import UIKit

//Extension of UIViewController to add ability to display an alert, dismiss the vitural keyboard and disable button if needed
extension UIViewController {
    /// Display an iOS alert to the user
    /// - Parameters:
    ///   - title: Alert's title
    ///   - message: Alert's message
    ///   - actions: List of action otpions which could be included within the alert. (By default = nil)
    func displayAnAlert(title: String, message: String, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// Hide the iOS keyboard. When called the UITextField provided is no longer first responder
    /// - Parameter firstResponder:UITextField to make resign
    func dismissKeyboard(firstResponder: UITextField) {
        firstResponder.resignFirstResponder()
    }
    
    /// Easy way to enable/disable a UIbuttons and change their style in the same time
    /// - Parameters:
    ///   - buttons: array of UIbutton to update
    ///   - isEnable: state to apply to the UIButtons
    func toggleButtonState(buttons: [UIButton], isEnable: Bool) {
        for oneButton in buttons {
            if !isEnable {
                oneButton.isEnabled = false
                oneButton.alpha = 0.5
            } else {
                oneButton.isEnabled = true
                oneButton.alpha = 1.0
            }
        }
    }
}
