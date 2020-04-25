//
//  CatInfoTableViewController.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit

class CatInfoTableViewController: UITableViewController {
   var catPhotos: [PhotoInfo]?
   override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.estimatedRowHeight = 85.0
      self.tableView.rowHeight = UITableViewAutomaticDimension
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let catPhotos = catPhotos else {
         return 0;
      }
      return catPhotos.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "catInfo", for: indexPath) as? CatInfoTableViewCell else {
         return UITableViewCell()
      }
      
      if let catPhotos = catPhotos {
         cell.catCaption.text = catPhotos[indexPath.row].caption
         cell.catTitle.text = catPhotos[indexPath.row].title
         if let data = (try? Data(contentsOf: URL(string: catPhotos[indexPath.row].url)!, options: [])) {
            cell.imageView?.image = UIImage(data: data)
         }
      }
      return cell
   }
}
