//
//  ViewController.swift
//  Swifty Protein
//
//  Created by Dillon MATHER on 2017/12/05.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var TouchIDButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    var passTouchID : Bool = false

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if passTouchID == true {
            passTouchID = false
            return true
        } else {
            return false
        }
    }

    @IBAction func TouchID(_ sender: Any) {
        if self.passTouchID == true {
            return
        } else {
            let context:LAContext = LAContext()
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "TouchID to Login ", reply: { (wasSuccessful, error) in
                    if wasSuccessful {
                        self.passTouchID = true
                        DispatchQueue.main.async(){
                            self.TouchIDButton.sendActions(for: .touchUpInside)
                        }
                    } else {
                        self.passTouchID = false
                        self.createAlert(title: "Error", message: "Invalid TouchID")
                    }
                })
            }
        }
    }

    @IBAction func LoginAction(_ sender: Any) {
        if (UsernameField.text == "admin" && PasswordField.text == "admin") {
            PasswordField.text = ""
            passTouchID = true
        } else {
            createAlert(title: "Login Error", message: "Invalid Login Credentials. Try Again.")
            PasswordField.text = ""
            passTouchID = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LoginButton.layer.cornerRadius = 10
        let context:LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            self.TouchIDButton.isHidden = false
        } else {
            self.TouchIDButton.isHidden = true
            createAlert(title: "Compatibility error", message: "Device does not support TouchID")
        }
    }

    /* alert func */
    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        print(message)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        };
    }
}

