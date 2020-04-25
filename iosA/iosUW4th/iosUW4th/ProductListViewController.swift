//
//  ProductListViewController.swift
//  iosUW4th
//
//  Created by wenyu zhao on 16/02/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var products:NSArray = []
    var cartList:NSMutableDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let path = Bundle.main.path(forResource: "ProductInfo", ofType: "plist") {
            if let dict = NSDictionary.init(contentsOfFile: path) {
                if let productArray = dict.value(forKey: "products") as? NSArray {
                    products = productArray
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productInfo",
                                                       for: indexPath) as? ProductInfoTableViewCell else {
            return UITableViewCell()
        }
        if let cellInfor = products.object(at: indexPath.row) as? NSDictionary {
            cell.imageView?.image = UIImage.init(named: (cellInfor.object(forKey: "imageName") as? String)!)
            cell.productPrice.text = cellInfor.object(forKey: "price") as? String
            cell.productDescription.text = cellInfor.object(forKey: "description") as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellInfo = products.object(at: indexPath.row) as? NSDictionary {
            if let productName = cellInfo.object(forKey: "imageName") as? String {
                if let productOfCartDict = self.cartList.object(forKey: productName) as? NSMutableDictionary {
                    if var number = productOfCartDict.object(forKey: "quantity") as? Int {
                        number+=1
                        productOfCartDict.setValue(number, forKey: "quantity")
                    } else {
                        productOfCartDict.setValue(1, forKey: "quantity")
                    }
                    if let selectedCell = tableView.cellForRow(at: indexPath) as? ProductInfoTableViewCell {
                        if let imageName = cellInfo.object(forKey: "imageName") as? String {
                            productOfCartDict.setValue(imageName, forKey: "image")
                        }
                        productOfCartDict.setValue(selectedCell.productDescription.text, forKey: "description")
                        productOfCartDict.setValue(selectedCell.productPrice.text, forKey: "price")
                    }
                    self.cartList.setValue(productOfCartDict, forKey: productName)
                } else {
                    let productOfCartDict:NSMutableDictionary = [:]
                    productOfCartDict.setValue(1, forKey: "quantity")
                    if let selectedCell = tableView.cellForRow(at: indexPath) as? ProductInfoTableViewCell {
                        if let imageName = cellInfo.object(forKey: "imageName") as? String {
                            productOfCartDict.setValue(imageName, forKey: "image")
                        }
                        productOfCartDict.setValue(selectedCell.productDescription.text, forKey: "description")
                        productOfCartDict.setValue(selectedCell.productPrice.text, forKey: "price")
                    }
                    self.cartList.setValue(productOfCartDict, forKey: productName)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCart" {
            if let dvc = segue.destination as? ShoppingCartViewController {
                dvc.cartList = cartList
            }
        }
    }
}

