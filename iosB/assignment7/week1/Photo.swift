//
//  Photo.swift
//  
//
//  Created by Ryan Zhao on 2018/6/22.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
   @NSManaged public var caption: String?
   @NSManaged public var title: String?
   @NSManaged public var url: String?
   @NSManaged public var cat: Cat?
}
