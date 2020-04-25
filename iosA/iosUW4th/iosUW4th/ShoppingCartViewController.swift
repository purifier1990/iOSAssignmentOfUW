//
//  ShoppingCartViewController.swift
//  iosUW4th
//
//  Created by wenyu zhao on 16/02/2018.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    var cartList:NSMutableDictionary = [:]
    var cartProductName:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutButton.isEnabled = false
        cartTableView.estimatedRowHeight = 56
        cartTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
        let namelist = cartList.allKeys as NSArray
        cartProductName = NSMutableArray.init(array: namelist)
        var grandInfo = ""
        var sumNumber = 0.0
        for product in cartProductName {
            if let dict = cartList.object(forKey: product) as? NSDictionary {
                grandInfo += cartInfo(from: dict).0
                sumNumber += cartInfo(from: dict).1
            }
        }
        grandTotalLabel.text = "\(grandInfo) are totally $\(sumNumber)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clear(_ sender: UIBarButtonItem) {
        self.cartList.removeAllObjects()
        self.cartTableView.reloadData()
        self.grandTotalLabel.text = ""
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartInfo",
                                                       for: indexPath) as? CartInfoTableViewCell else {
                                                        return UITableViewCell()
        }
        if let name = self.cartProductName.object(at: indexPath.row) as? String {
            if let productDict = self.cartList.object(forKey: name) as? NSDictionary {
                cell.productImage.image = UIImage.init(named: productDict.object(forKey: "image") as! String)
                if let number = productDict.object(forKey: "quantity") as? Double, let price = productDict.object(forKey: "price") as? String {
                    let total = number * Double(price)!
                    cell.productQuantity.text = "\(Int(number))"
                    cell.productPrice.text = "\(total)"
                    cell.productDescription.text = (productDict.object(forKey: "description") as! String)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            if let name = self.cartProductName.object(at: indexPath.row) as? String {
                self.cartList.removeObject(forKey: name)
            }
            self.cartProductName.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
        }
        return [deleteAction]
    }
    
    func cartInfo(from dict:NSDictionary) -> (String, Double) {
        var info = ""
        var sum = 0.0
        if let number = dict.object(forKey: "quantity") as? Int, let price = dict.object(forKey: "price") as? String {
            sum = Double(number) * Double(price)!
            info += "\(number) "
            info += dict.object(forKey: "image") as! String
            info += " "
        }
        return (info, sum)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
