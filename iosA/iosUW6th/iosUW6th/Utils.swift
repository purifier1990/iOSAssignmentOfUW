//
//  Utils.swift
//  iosUW6th
//
//  Created by wenyu zhao on 10/03/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

public class Utils: NSObject {
    public func getImage(imageName:String, closure:(_ image:UIImage?) -> Void) ->Void {
        closure(UIImage.init(named: imageName, in: Bundle.init(for: Utils.self), compatibleWith: nil))
    }
    public func getAllImageNames() -> Array<String> {
        return ["girl", "pal", "saski", "scene", "taipei"]
    }
}
