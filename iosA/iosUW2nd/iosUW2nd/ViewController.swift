//
//  ViewController.swift
//  iosUW2nd
//
//  Created by wenyu zhao on 03/02/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

let KG = "kg"
let METER = "m"
let POND = "lb"
let FEET = "in"
let inchToMeter = 0.0254
let lbToKg = 0.4535924

class ViewController: UIViewController {
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var BMI: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var lenghLabel: UILabel!
    @IBOutlet weak var switchMeasure: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func calcu(_ sender: Any) {
        guard let weightStr = weightTextField.text, let heightStr = lengthTextField.text else {
            print("This is not right")
            return
        }
        if let weightNumber = NumberFormatter().number(from: weightStr), let heightNumber = NumberFormatter().number(from: heightStr) {
            var bmi = 0.0
            var weight = Double(truncating: weightNumber)
            var height = Double(truncating: heightNumber)
            if !switchMeasure.isOn {
                (weight, height) = convert(lb: weight, inch: height)
            }
            bmi = weight / (height * height)
            BMI.text = String(format: "%.2f", bmi) + "kg/㎡"
        }
    }
    
    @IBAction func changeMeasure(_ sender: Any) {
        if switchMeasure.isOn {
            weightLabel.text = KG
            lenghLabel.text = METER
            weightTextField.placeholder = KG
            lengthTextField.placeholder = METER
        } else {
            weightLabel.text = POND
            lenghLabel.text = FEET
            weightTextField.placeholder = POND
            lengthTextField.placeholder = FEET
        }
    }

    func convert(lb: Double, inch: Double) -> (kg:Double, m:Double) {
        return (lb * lbToKg, inch * inchToMeter)
    }
}

