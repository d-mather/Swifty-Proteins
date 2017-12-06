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

    @IBOutlet weak var TouchIDButton: UIButton!

    @IBAction func TouchID(_ sender: Any) {
        let context:LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "TouchID to Login ", reply: { (wasSuccessful, error) in
                if wasSuccessful {
                    print("Successful")
                } else {
                    print("Not Successful")
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context:LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            self.TouchIDButton.isHidden = false
        } else {
            self.TouchIDButton.isHidden = true
            print("Device does not support TouchID")
        }
    }

    /* alert func */
    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

