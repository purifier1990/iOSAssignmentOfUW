//
//  imageFetchingOperationQueue.swift
//  week1
//
//  Created by wenyuzhao on 19/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit

class imageFetchingOperationQueue: Operation {
   var photo:UIImage?
   var url:URL?
   
   private var _executing = false {
      willSet {
         willChangeValue(forKey: "isExecuting")
      }
      didSet {
         didChangeValue(forKey: "isExecuting")
      }
   }
   
   override var isExecuting: Bool {
      return _executing
   }
   
   private var _finished = false {
      willSet {
         willChangeValue(forKey: "isFinished")
      }
      didSet {
         didChangeValue(forKey: "isFinished")
      }
   }
   
   override var isFinished: Bool {
      return _finished
   }
   
   func executing(_ executing:Bool) {
      _executing = executing
   }
   
   func finish(_ finished:Bool) {
      _finished = finished
   }
   
   init(url: String) {
      self.url = URL.init(string: url)
   }
   
   override func main() {
      guard isCancelled == false else {
         finish(true)
         return
      }
      
      executing(true)
      guard
         let imageData = (try? Data.init(contentsOf: self.url!))
         else {
               executing(false)
               finish(true)
               return
      }
      
      self.photo = UIImage.init(data: imageData)
      executing(false)
      finish(true)
   }
}
