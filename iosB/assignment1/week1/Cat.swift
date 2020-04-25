//
//  Cat.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import Foundation

class Cat {
   let age: Double
   let name : String
   let location: Location?
   private(set) var photos: [PhotoInfo] = []
   
   init?(jsonDict: [String: Any]?) {
      guard let jsonDict = jsonDict else {
         return nil
      }
      guard let age = jsonDict["age"] as? Double else {
         return nil
      }
      guard let name = jsonDict["name"] as? String else {
         return nil
      }
      self.age = age
      self.name = name
      self.location = Location(jsonDict: jsonDict["location"] as? [String: Any])
      if let photoArray = jsonDict["photos"] as? [[String: Any]] {
         for photoDict in photoArray {
            if let photo = PhotoInfo(jsonDict: photoDict) {
               photos.append(photo)
            }
         }
      }
   }
}
