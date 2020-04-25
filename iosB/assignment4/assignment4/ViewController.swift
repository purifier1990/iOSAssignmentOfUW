//
//  ViewController.swift
//  assignment4
//
//  Created by wenyuzhao on 09/05/2018.
//  Copyright © 2018 wenyuzhao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

   let mapView = MKMapView()
   let pinCoords = [CLLocationCoordinate2DMake(47.51, -122.25),
                    CLLocationCoordinate2DMake(47.52, -122.26)]
   let locationManager = CLLocationManager()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      
      mapView.translatesAutoresizingMaskIntoConstraints = false
      mapView.delegate = self
      view.addSubview(mapView)
      
      let center = CLLocationCoordinate2DMake(47.5, -122.3)
      let span = MKCoordinateSpanMake(0.1, 0.1)
      mapView.setRegion(MKCoordinateRegionMake(center, span), animated: false)
      
      let safeArea = view.safeAreaLayoutGuide
      mapView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
      mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
      mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
      mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
      
      for coord in self.pinCoords {
         let annotation = MKPointAnnotation()
         annotation.title = "City of Cats"
         annotation.coordinate = coord
         mapView.addAnnotation(annotation)
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
   
   func fetchDirectionsToPin(coord: CLLocationCoordinate2D) {
      let request = MKDirectionsRequest()
      let destination = MKPlacemark.init(coordinate: coord)
      let source = MKPlacemark.init(coordinate: mapView.userLocation.coordinate)
      request.destination = MKMapItem.init(placemark: destination)
      request.source = MKMapItem.init(placemark: source)
      
      let directions = MKDirections.init(request: request)
      directions.calculate { (response: MKDirectionsResponse?, error: Error?) in
         guard let response = response else {
            return
         }
         guard let route = response.routes.first else {
            return
         }
         
         for step in route.steps {
            print(step.instructions)
         }
         
         self.mapView.add(route.polyline, level: .aboveRoads)
      }
   }
}

extension ViewController: MKMapViewDelegate {
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
         if let coord = view.annotation?.coordinate {
            self.fetchDirectionsToPin(coord: coord)
         }
      }
      print("Callout was tapped")
   }
   
   func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer.init(overlay: overlay)
      renderer.strokeColor = UIColor.init(red: 0, green: 0, blue: 2.0, alpha: 0.1)
      return renderer
   }
}

extension ViewController:CLLocationManagerDelegate {
   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      if status == .authorizedWhenInUse || status == .authorizedAlways {
         manager.requestLocation()
      }
   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      mapView.showsUserLocation = true
   }
   
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print(error)
   }
}
