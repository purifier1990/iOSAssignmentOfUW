//
//  LoginViewController.swift
//  assignment6
//
//  Created by wenyuzhao on 11/05/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

   let serverName = "assignment6"
   
   @IBOutlet weak var passwordTextfield: UITextField!
   @IBOutlet weak var usernameTextField: UITextField!
   override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   func readFromKeychain(key: String) -> String? {
      let pw = KeychainPasswordItem(service: serverName, account: key)
      
      do {
         return try pw.readPassword()
      } catch {
         let alert = UIAlertController(title: "Alert", message: "username not existed", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return nil
      }
   }

   @IBAction func onLogin(_ sender: Any) {
      if let key = usernameTextField.text {
         if let pwFromDefaults = readFromKeychain(key: key), let pwFromTextFiled = passwordTextfield.text {
            if pwFromDefaults == pwFromTextFiled {
               self.performSegue(withIdentifier: "beginMainApp", sender: nil)
            } else {
               let alert = UIAlertController(title: "Alert", message: "username or password not right", preferredStyle: UIAlertControllerStyle.alert)
               alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
            }
         }
      }
   }
}
