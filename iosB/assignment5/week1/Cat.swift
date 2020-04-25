//
//  Cat.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import Foundation

class Cat: Codable {
   private(set) var age: Double? = 0
   private(set) var name : String = ""
   private(set) var location: Location?
   private(set) var photos: [PhotoInfo]? = []
}
