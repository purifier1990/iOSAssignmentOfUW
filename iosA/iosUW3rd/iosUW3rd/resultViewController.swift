//
//  resultViewController.swift
//  iosUW3rd
//
//  Created by wenyu zhao on 11/02/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

class resultViewController: UIViewController {

    @IBOutlet weak var resultText: UITextView!
    var choiceString = Personality()
    override func viewDidLoad() {
        super.viewDidLoad()
        let point = choiceString.getCharacterPoint(choiceString)
        let stringResult = choiceString.getTextOfCharacter(choiceString.getCharacterResult(point))
        resultText.text = stringResult
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
   

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "ok" {
//            dismiss(animated: true, completion: nil)
//            if let dwc = segue.destination as? ViewController {
//               let top = UIApplication.shared.keyWindow?.rootViewController
//               top?.present(dwc, animated: true, completion: nil)
//            }
//        }
//    }

}
