//
//  ViewController.swift
//  357Final
//
//  Created by Mike on 12/11/20.
//

import UIKit
import MapKit

class ViewController: UIViewController {
  @IBOutlet private var mapView: MKMapView!
  private var buildings: [Location] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set initial location in GVSU
    let initialLocation = CLLocation(latitude: 42.96345, longitude: -85.88860)
    mapView.centerToLocation(initialLocation)
    
    let GvCenter = CLLocation(latitude: 42.96345, longitude: -85.88860)
    let region = MKCoordinateRegion(
      center: GvCenter.coordinate,
      latitudinalMeters: 50000,
      longitudinalMeters: 60000)
    mapView.setCameraBoundary(
      MKMapView.CameraBoundary(coordinateRegion: region),
      animated: true)
    
    let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
    mapView.setCameraZoomRange(zoomRange, animated: true)
    
    mapView.delegate = self
    
    mapView.register(
      LocationView.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    
    loadInitialData()
    mapView.addAnnotations(buildings)
    
    //Show our locations on the map
    let clockTower = Location(
      title: "Cook Carillon Clock Tower",
      locationName: "Lets be real. We're all kinda thinking about jumping right now",
        coordinate: CLLocationCoordinate2D(latitude: 42.963425, longitude: -85.888595))
    mapView.addAnnotation(clockTower)
    
    let SupremeHappiness = Location(
      title: "Qdoba",
      locationName: "Happiest Place on Campus",
        coordinate: CLLocationCoordinate2D(latitude: 42.96305, longitude: -85.89212))
    mapView.addAnnotation(SupremeHappiness)
    
    let DullThePain = Location(
      title: "Harry's One Stop",
      locationName: "Just Drink till it doesn't hurt",
        coordinate: CLLocationCoordinate2D(latitude: 42.96420, longitude: -85.90464))
    mapView.addAnnotation(DullThePain)
    
  }
    
    
    
  
  private func loadInitialData() {
    // 1
    guard
      let fileName = Bundle.main.url(forResource: "GvBuildings", withExtension: "geojson"),
      let artworkData = try? Data(contentsOf: fileName)
      else {
        return
    }
    
    do {
      // 2
      let features = try MKGeoJSONDecoder()
        .decode(artworkData)
        .compactMap { $0 as? MKGeoJSONFeature }
      // 3
      let validWorks = features.compactMap(Location.init)
      // 4
      buildings.append(contentsOf: validWorks)
    } catch {
      // 5
      print("Unexpected error: \(error).")
    }
  }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension ViewController: MKMapViewDelegate {
  // 1
  func mapView(
    _ mapView: MKMapView,
    viewFor annotation: MKAnnotation
  ) -> MKAnnotationView? {
    // 2
    guard let annotation = annotation as? Location else {
      return nil
    }
    // 3
    let identifier = "building"
    var view: MKMarkerAnnotationView
    // 4
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      // 5
      view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
    
    func mapView(
      _ mapView: MKMapView,
      annotationView view: MKAnnotationView,
      calloutAccessoryControlTapped control: UIControl
    ) {
      guard let building = view.annotation as? Location else {
        return
      }

      let launchOptions = [
        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
      ]
      building.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}
    


