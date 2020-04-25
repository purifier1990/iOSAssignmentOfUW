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
   var catsArray:[Cat] = []
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
               let jsonDict = self.parseJsonFromData(data: data)
               self.catsArray = self.parseDictIntoCatsArray(jsonDict: jsonDict)
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
   
   func parseJsonFromData(data: Data) -> [String: Any] {
      return ((try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any])!
   }
   
   func parseDictIntoCatsArray(jsonDict: [String: Any]?) -> [Cat] {
      var catsArray:[Cat] = []
      guard let catsJsonArray = jsonDict?["cats"] as? [[String: Any]] else {
         return catsArray
      }
      for catJsonDict in catsJsonArray {
         if let cat = Cat(jsonDict: catJsonDict) {
            catsArray.append(cat)
         }
      }
      return catsArray
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showDetail" {
         if let dvc = segue.destination as? CatInfoTableViewController {
            if let catItem = sender as? CatListTableViewCell {
               for cat in catsArray {
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
      return catsArray.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "catList", for: indexPath) as? CatListTableViewCell else {
         return UITableViewCell()
      }
      cell.catName.text = catsArray[indexPath.row].name
      return cell
   }
}

