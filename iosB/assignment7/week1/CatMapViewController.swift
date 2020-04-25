//
//  CatMapViewController.swift
//  assignment4
//
//  Created by wenyuzhao on 09/05/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class CatMapViewController: UIViewController {

   let urlString = "https://uw-pce-iphone-125-spring-2018.firebaseio.com/purifier.json"
   let mapView = MKMapView()
   var catNameTapped: String?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      
      mapView.translatesAutoresizingMaskIntoConstraints = false
      mapView.delegate = self
      view.addSubview(mapView)
      
      parseCatData()
      
      let center = CLLocationCoordinate2DMake(47.6, -122.3)
      let span = MKCoordinateSpanMake(0.1, 0.1)
      mapView.setRegion(MKCoordinateRegionMake(center, span), animated: false)
      
      let safeArea = view.safeAreaLayoutGuide
      mapView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
      mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
      mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
      mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
   }

   func parseCatData() {
      let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
      do {
         let locations = try AppDelegate.moc.fetch(fetchRequest)
         for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.cat?.name
            annotation.coordinate = CLLocationCoordinate2DMake(location.lat, location.long)
            self.mapView.addAnnotation(annotation)
         }
      } catch {
         print("\(error)")
      }
   }
   
   func pinSizedImage(from image:UIImage?) -> UIImage? {
      guard let image = image else {
         return nil
      }
      let newSize = CGSize.init(width: 25, height: 30)
      UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
      image.draw(in: CGRect.init(origin: .zero, size: newSize))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showDetail" {
         if let dvc = segue.destination as? CatInfoTableViewController {
            dvc.selectedCat = self.catNameTapped
         }
      }
   }
}

extension CatMapViewController: MKMapViewDelegate {
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      if type(of: annotation) == MKUserLocation.self {
         return nil
      }
      let viewId = "myAnnotationViewId"
      var view = mapView.dequeueReusableAnnotationView(withIdentifier: viewId)
      if view == nil {
         view = MKAnnotationView.init(annotation: annotation, reuseIdentifier: viewId)
      }
      view?.image = pinSizedImage(from: UIImage.init(named: "itachi"))
      view?.canShowCallout = true
      let rightButton = UIButton.init(type: .detailDisclosure)
      view?.rightCalloutAccessoryView = rightButton
      return view
   }
   
   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         self.catNameTapped = view.annotation?.title ?? nil
         self.performSegue(withIdentifier: "showDetail", sender: self.mapView)
      }
      print("Callout was tapped")
   }
}
