//
//  ProductInfoTableViewCell.swift
//  iosUW4th
//
//  Created by wenyu zhao on 16/02/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

class ProductInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
