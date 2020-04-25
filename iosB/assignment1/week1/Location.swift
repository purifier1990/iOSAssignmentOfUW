//
//  Location.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import Foundation

struct Location {
   let lat: Double
   let long: Double
   
   init?(jsonDict: [String: Any]?) {
      guard let jsonDict = jsonDict else {
         return nil
      }
      guard let lat = jsonDict["lat"] as? Double else {
         return nil
      }
      guard let long = jsonDict["long"] as? Double else {
         return nil
      }
      self.lat = lat
      self.long = long
   }
}
