//
//  Location.swift
//  
//
//  Created by Ryan Zhao on 2018/6/22.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {
   @NSManaged public var lat: Double
   @NSManaged public var long: Double
   @NSManaged public var cat: Cat?
}
