//
//  ViewController.swift
//  week1
//
//  Created by wenyuzhao on 16/04/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController {

   @IBOutlet weak var catTableview: UITableView!
   let urlString = "https://uw-pce-iphone-125-spring-2018.firebaseio.com/purifier.json"
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      parseCatData()
      self.catTableview.estimatedRowHeight = 85.0
      self.catTableview.rowHeight = UITableViewAutomaticDimension
   }
   
   func parseCatData() {
      if let catURL = URL(string: urlString) {
         let task = URLSession.shared.dataTask(with: catURL) { (data:Data?, response:URLResponse?, error:Error?) in
            if let response = response as? HTTPURLResponse, let data = data {
               if response.statusCode == 200 {
                  let fetchRequest = NSFetchRequest<Cat>(entityName: "Cat")
                  do {
                     let cats = try AppDelegate.moc.fetch(fetchRequest)
                     for cat in cats {
                        AppDelegate.moc.delete(cat)
                     }
                     do {
                        try AppDelegate.moc.save()
                     } catch {
                        print("\(error)")
                     }
                  } catch {
                     print("\(error)")
                  }
                  if let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] {
                     if let catDists = jsonArray["cats"] as? [[String: Any]] {
                        for catDict in catDists {
                           if let newCat = NSEntityDescription.insertNewObject(forEntityName: "Cat", into: AppDelegate.moc) as? Cat {
                              if let name = catDict["name"] as? String {
                                 newCat.name = name
                              }
                              if let age = catDict["age"] as? Double {
                                 newCat.age = age
                              }
                              if let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: AppDelegate.moc) as? Location {
                                 if let location = catDict["location"] as? [String: Double] {
                                    newLocation.lat = location["lat"]!
                                    newLocation.long = location["long"]!
                                    newLocation.cat = newCat
                                 }
                              }
                              if let photoArray = catDict["photos"] as? [[String: String]] {
                                 for photo in photoArray {
                                    if let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: AppDelegate.moc) as? Photo {
                                       newPhoto.caption = photo["caption"]
                                       newPhoto.title = photo["title"]
                                       newPhoto.url = photo["url"]
                                       newPhoto.cat = newCat
                                    }
                                 }
                              }
                           }
                        }
                     }
                     do {
                        try AppDelegate.moc.save()
                     } catch {
                        print("\(error)")
                     }
                  }
               }
            }
         }
         task.resume()
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showDetail" {
         if let dvc = segue.destination as? CatInfoTableViewController {
            if let catItem = sender as? CatListTableViewCell {
               dvc.selectedCat = catItem.catName.text
            }
         }
      }
   }
}

extension ViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let fetchRequest = NSFetchRequest<Cat>(entityName: "Cat")
      do {
         let cat = try AppDelegate.moc.fetch(fetchRequest)
         return cat.count
      } catch {
         print("\(error)")
         return 0
      }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "catList", for: indexPath) as? CatListTableViewCell else {
         return UITableViewCell()
      }
      let fetchRequest = NSFetchRequest<Cat>(entityName: "Cat")
      do {
         let cat = try AppDelegate.moc.fetch(fetchRequest)
         cell.catName.text = cat[indexPath.row].name
         if let location = cat[indexPath.row].locationOfCat {
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
      } catch {
         print("\(error)")
      }
      return cell
   }
}

