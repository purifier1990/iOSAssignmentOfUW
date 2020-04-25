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
   let oq = OperationQueue()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.estimatedRowHeight = 85.0
      self.tableView.rowHeight = UITableViewAutomaticDimension
      oq.qualityOfService = .background
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
         let imageQueue = imageFetchingOperationQueue(url: catPhotos[indexPath.row].url)
         imageQueue.completionBlock = {
            DispatchQueue.main.async {
               cell.catImage.image = imageQueue.photo
               self.tableView.reloadData()
            }
         }
         oq.addOperation(imageQueue)
      }
      return cell
   }
}
