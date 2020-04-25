//
//  PhotoInfor.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import Foundation

struct PhotoInfo {
   let caption: String?
   let title: String?
   let url: String

   init?(jsonDict: [String:Any]?) {
      guard let jsonDict = jsonDict else {
         return nil
      }
      guard let url = jsonDict["url"] as? String else {
         return nil
      }
      self.url = url
      self.title = jsonDict["title"] as? String
      self.caption = jsonDict["caption"] as? String
   }
}
