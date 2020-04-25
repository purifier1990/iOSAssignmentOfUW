//
//  CartInfoTableViewCell.swift
//  iosUW4th
//
//  Created by wenyu zhao on 16/02/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

class CartInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
