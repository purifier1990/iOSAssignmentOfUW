//
//  ViewController.swift
//  iosUW3rd
//
//  Created by wenyu zhao on 10/02/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

var choiceResult = Personality()
class ViewController: UIViewController {
    @IBOutlet var singleChoice: [UIButton]!
    @IBOutlet var multiChoices: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func singleChoiceMake(_ sender: UIButton) {
        for button in singleChoice {
            if button == sender {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func multiChoiceMake(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submit" {
            for button in multiChoices {
                if button.isSelected {
                    if let text = button.titleLabel?.text {
                        choiceResult.fifthQuestion.append(text)
                    }
                }
            }
            if let dwc = segue.destination as? resultViewController {
                dwc.choiceString = choiceResult
            }
        } else if segue.identifier == "first" {
            for button in singleChoice {
                if button.isSelected {
                    if let text = button.titleLabel?.text {
                        choiceResult.firstQuestion = text
                    }
                }
            }
        } else if segue.identifier == "second" {
            for button in singleChoice {
                if button.isSelected {
                    if let text = button.titleLabel?.text {
                        choiceResult.secondQuestion = text
                    }
                }
            }
        } else if segue.identifier == "third" {
            for button in singleChoice {
                if button.isSelected {
                    if let text = button.titleLabel?.text {
                        choiceResult.thirdQuestion = text
                    }
                }
            }
        } else if segue.identifier == "fourth" {
            for button in multiChoices {
                if button.isSelected {
                    if let text = button.titleLabel?.text {
                        choiceResult.fouthQuestion.append(text)
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

