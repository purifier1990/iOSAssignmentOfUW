//
//  ViewController.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var catTableview: UITableView!
   let urlString = "https://uw-pce-iphone-125-spring-2018.firebaseio.com/purifier.json"
   var catsInfo: CatsInfo?
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      parseCatData()
   }
   
   func parseCatData() {
      if let catURL = URL(string: urlString) {
         let catURLRequest = URLRequest(url: catURL)
         let task = URLSession.shared.dataTask(with: catURLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            if let error = error {
               print(error)
               return
            }
            guard let response = response as? HTTPURLResponse, let data = data else {
               print("no response")
               return
            }
            if response.statusCode == 200 {
               self.catsInfo = (try? JSONDecoder().decode(CatsInfo.self, from: data))
               DispatchQueue.main.async {
                  self.catTableview.reloadData()
               }
            } else {
               print("status is not good")
            }
         }
         task.resume()
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showDetail" {
         if let dvc = segue.destination as? CatInfoTableViewController {
            if let catItem = sender as? CatListTableViewCell, let catsInfo = self.catsInfo {
               for cat in catsInfo.cats {
                  if cat.name == catItem.catName.text {
                     dvc.catPhotos = cat.photos
                  }
               }
            }
         }
      }
   }
}

extension ViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if let catsInfo = self.catsInfo {
         return catsInfo.cats.count
      }
      return 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "catList", for: indexPath) as? CatListTableViewCell else {
         return UITableViewCell()
      }
      if let catsInfo = self.catsInfo {
         cell.catName.text = catsInfo.cats[indexPath.row].name
      }
      return cell
   }
}

