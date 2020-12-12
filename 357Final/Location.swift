import Foundation
import MapKit
import Contacts

class Location: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let coordinate: CLLocationCoordinate2D
  
  init(
    title: String?,
    locationName: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    //self.discipline = discipline
    self.coordinate = coordinate
    
    super.init()
  }
  
  init?(feature: MKGeoJSONFeature) {
    
    guard
      let point = feature.geometry.first as? MKPointAnnotation,
    
      let propertiesData = feature.properties,
      let json = try? JSONSerialization.jsonObject(with: propertiesData),
      let properties = json as? [String: Any]
      else {
        return nil
    }
    
    // 3
    title = properties["title"] as? String
    locationName = properties["location"] as? String
    coordinate = point.coordinate
    super.init()
  }
  
  var subtitle: String? {
    return locationName
  }
  
  var mapItem: MKMapItem? {
    guard let location = locationName else {
      return nil
    }
    
    let addressDict = [CNPostalAddressStreetKey: location]
    let placemark = MKPlacemark(
      coordinate: coordinate,
      addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }
  
  var image: UIImage {
    guard let name = locationName else { return #imageLiteral(resourceName: "Flag") }
    
    switch name {
    case "Cook Carillon Clock Tower":
      return #imageLiteral(resourceName: "360px-Cook_Carillon_Tower")
    case "Qdoba":
      return #imageLiteral(resourceName: "GVLogo")
    case "Plaque":
      return #imageLiteral(resourceName: "Plaque")
    case "Mural":
      return #imageLiteral(resourceName: "Mural")
    default:
      return #imageLiteral(resourceName: "GVLogo")
    }
  }
}
