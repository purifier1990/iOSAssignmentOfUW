//
//  CatInfoTableViewController.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit
import CoreData

class CatInfoTableViewController: UITableViewController {
   var selectedCat: String?
   let oq = OperationQueue()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.estimatedRowHeight = 85.0
      self.tableView.rowHeight = UITableViewAutomaticDimension
      oq.qualityOfService = .background
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
      do {
         var count = 0
         let photos = try AppDelegate.moc.fetch(fetchRequest)
         for photo in photos {
            if photo.cat?.name == selectedCat {
               count += 1
            }
         }
         return count
      } catch {
         print("\(error)")
         return 0
      }
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "catInfo", for: indexPath) as? CatInfoTableViewCell else {
         return UITableViewCell()
      }
      
      let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
      do {
         let photos = try AppDelegate.moc.fetch(fetchRequest)
         cell.catCaption.text = photos[indexPath.row].caption
         cell.catTitle.text = photos[indexPath.row].title
         let imageQueue = imageFetchingOperationQueue(url: photos[indexPath.row].url!)
         imageQueue.completionBlock = {
            DispatchQueue.main.async {
               cell.catImage.image = imageQueue.photo
               self.tableView.reloadData()
            }
         }
         oq.addOperation(imageQueue)
      } catch {
         print("\(error)")
      }
      return cell
   }
}
