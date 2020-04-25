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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: UserDefaults.didChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateUI() {
        if UserDefaults.standard.bool(forKey: "isMetric") {
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
    
    @IBAction func calcu(_ sender: Any) {
        guard let weightStr = weightTextField.text, let heightStr = lengthTextField.text else {
            print("This is not right")
            return
        }
        if var weight = Double(weightStr), var height = Double(heightStr){
            if !UserDefaults.standard.bool(forKey: "isMetric") {
                (weight, height) = convert(lb: weight, inch: height)
            }
            let bmi = calcu(weight: weight, height: height)
            BMI.text = String(format: "%.2f", bmi) + "kg/㎡"
        }
    }
    
    func calcu<T:CalculateNumber>(weight:T, height:T) -> T {
        return weight / (height * height)
    }
    
    func convert(lb: Double, inch: Double) -> (kg:Double, m:Double) {
        return (lb * lbToKg, inch * inchToMeter)
    }
}

protocol CalculateNumber {
    static func /(lhs: Self, rhs:Self) -> Self
    static func *(lhs: Self, rhs:Self) -> Self
}

extension Int64 : CalculateNumber {
    
}

extension Int32 : CalculateNumber {

}

extension Int16 : CalculateNumber {

}

extension Int8 : CalculateNumber {

}

extension Double : CalculateNumber {

}

extension Float : CalculateNumber {
    
}
