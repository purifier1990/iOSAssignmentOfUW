//
//  Personality.swift
//  iosUW3rd
//
//  Created by wenyuzhao on 12/02/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import Foundation

let valueForA = 4
let valueForB = 2
let valueForC = 1

enum CharacterRate {
    case first
    case second
    case third
}

let firstQuizAnswerOfOne = "Never"
let firstQuizAnswerOfTwo = "A little"
let firstQuizAnswerofThree = "Often"

let secondQuizAnswerOfOne = "None of them is important"
let secondQuizAnswerOfTwo = "Career is more important"
let secondQuizAnswerOfThree = "Friends are more important"
let secondQuizAnswerOfFour = "Both of them are important"

let thirdQuizAnswerOfOne = "Not at all"
let thirdQuizAnswerOfTwo = "More or less"
let thirdQuizAnswerOfThree = "Definitely"

let fourQuizAnswerOfOne = "Football"
let fourQuizAnswerOfTwo = "Tennis"
let fourQuizAnswerOfThree = "Music"
let fourQuizAnswerOfFour = "Movie"
let fourQuizAnswerOfFive = "Drawing"

let fiveQuizAnswerOfOne = "Eating"
let fiveQuizAnswerOfTwo = "Gym"
let fiveQuizAnswerOfThree = "Crying"
let fiveQuizAnswerOfFour = "Calling to a friend"

class Personality {
    var firstQuestion:String?
    var secondQuestion:String?
    var thirdQuestion:String?
    var fouthQuestion:[String?] = []
    var fifthQuestion:[String?] = []
   
    func getCharacterPoint(_ quizAnswer: Personality) -> Int {
        var point = 0
        if let result = quizAnswer.firstQuestion {
            if result == firstQuizAnswerOfOne {
                point += valueForA
            } else if result == firstQuizAnswerOfTwo {
                point += valueForB
            } else {
                point += valueForC
            }
        }
        if let result = quizAnswer.secondQuestion {
            if result == secondQuizAnswerOfOne {
                point += valueForA
            } else if result == secondQuizAnswerOfTwo {
                point += valueForB
            } else {
                point += valueForC
            }
        }
        if let result = quizAnswer.thirdQuestion {
            if result == thirdQuizAnswerOfOne {
                point += valueForA
            } else if result == thirdQuizAnswerOfTwo {
                point += valueForB
            } else {
                point += valueForC
            }
        }
        for item in quizAnswer.fouthQuestion {
            if let result = item {
                if result == fourQuizAnswerOfOne || result == fourQuizAnswerOfTwo {
                    point += valueForA
                } else if result == fourQuizAnswerOfThree || result == fourQuizAnswerOfFour {
                    point += valueForB
                } else {
                    point += valueForC
                }
            }
        }
        for item in quizAnswer.fifthQuestion {
            if let result = item {
                if result == fiveQuizAnswerOfOne || result == fiveQuizAnswerOfTwo {
                    point += valueForA
                } else if result == fiveQuizAnswerOfThree {
                    point += valueForB
                } else {
                    point += valueForC
                }
            }
        }
        return point
    }
   
    func getCharacterResult(_ point: Int) -> CharacterRate {
        if point > valueForA * 3 {
            return .first
        } else if point > valueForB * 3 && point <= valueForA * 3 {
            return .second
        } else {
            return .third
        }
    }
   
    func getTextOfCharacter(_ character: CharacterRate) -> String {
        switch character {
        case .first:
            return "You are a very introvert person.\n You don't care about your life.\n Whatever it's good or not.\n You like to play sports.\n You tend to cheer yourself up by doing phsical activity alone."
        case .second:
            return "You are a neutral person.\n You are willing to have a good career.\n But current life is not that good as you expect.\n You like to listen to music or watch movie.\n You tend to cheer yourself up by releasing your mood"
        case .third:
            return "You are a very extrovert person.\n You want your friends to be happy.\n And you believe your life is great enough.\n You like to do some art stle activity.\n You tend to cheer yourself up via your friends"
        }
    }
}
