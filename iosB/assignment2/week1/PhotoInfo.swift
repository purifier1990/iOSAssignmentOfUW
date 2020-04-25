//
//  PhotoInfor.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import Foundation

struct PhotoInfo: Codable {
   private(set) var caption: String?
   private(set) var title: String?
   private(set) var url: String = ""
}
