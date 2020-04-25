//
//  ViewController.swift
//  assignment6
//
//  Created by wenyuzhao on 11/05/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

   let serverName = "assignment6"
   let usernameKey = "username"
   
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var usernameTextField: UITextField!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }

   func saveToKeychain(key: String, value: String) {
      let pw = KeychainPasswordItem(service: serverName, account: key)
      
      do {
       try pw.savePassword(value)
      } catch {
         print("error: \(error)")
      }
   }
   
   @IBAction func onRegister(_ sender: Any) {
      if let key = usernameTextField.text {
         UserDefaults.standard.set(key, forKey: usernameKey)
         if let pw = passwordTextField.text {
            saveToKeychain(key: key, value: pw)
         }
      }
   }
}

