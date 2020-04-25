//
//  ViewController.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

   @IBOutlet weak var catTableview: UITableView!
   let urlString = "https://uw-pce-iphone-125-spring-2018.firebaseio.com/purifier.json"
   var catsInfo: CatsInfo?
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      parseCatData()
      self.catTableview.estimatedRowHeight = 85.0
      self.catTableview.rowHeight = UITableViewAutomaticDimension
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
         if let location = catsInfo.cats[indexPath.row].location {
            let cl = CLLocation.init(latitude: location.lat, longitude: location.long)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(cl) { (placemarks:[CLPlacemark]?, error:Error?) in
               if let error = error {
                  print(error)
                  return
               }
               if let placemarks = placemarks {
                  for placemark in placemarks {
                     var street = " "
                     street.append(placemark.subThoroughfare ?? "")
                     street.append(" ")
                     street.append(placemark.thoroughfare ?? "")
                     cell.street.text = street
                     
                     var city = ""
                     city.append(placemark.locality ?? "")
                     city.append(", ")
                     city.append(placemark.administrativeArea ?? "")
                     city.append(" ")
                     city.append(placemark.postalCode ?? "")
                     cell.city.text = city
                     self.catTableview.reloadData()
                  }
               }
            }
         }
      }
      return cell
   }
}

