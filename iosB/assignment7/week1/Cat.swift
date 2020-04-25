//
//  Cat.swift
//  
//
//  Created by Ryan Zhao on 2018/6/22.
//
//

import Foundation
import CoreData

@objc(Cat)
public class Cat: NSManagedObject {
   @NSManaged public var age: Double
   @NSManaged public var name: String?
   @NSManaged public var locationOfCat: Location?
   @NSManaged public var photosOfCat: NSSet?
}
