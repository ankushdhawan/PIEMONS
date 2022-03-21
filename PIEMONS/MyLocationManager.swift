import Foundation
import CoreLocation

class MyLocationManager: NSObject, CLLocationManagerDelegate {
   
    private let locationManager = CLLocationManager()
    private var zipCode:String?
    private var city:String?
    private var newLocation: CLLocation?
   
    static let shared = MyLocationManager()
   
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()     // request will restart it

        locationManager.requestLocation()
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {     // Needed for request
        print("Some error")
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        newLocation = locations[locations.count - 1]//        print(locations.count)
        getPlacemarkFromLocation(newLocation!)

    }


     // I've isolated the func, but not really needed
    func getPlacemarkFromLocation(_ location: CLLocation) {
       
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [self](placemarks, error)-> Void in
            if error != nil {
                //AlertView to show the ERROR message
            }
            var addressString : String = ""

            if placemarks!.count > 0 {
                let placemark = placemarks![0]
                self.locationManager.stopUpdatingLocation()
                self.zipCode = placemark.postalCode ?? ""
                self.city = placemark.locality ?? ""
                    if placemark.subLocality != nil {
                        addressString = addressString + placemark.subLocality! + ", "
                    }
                    if placemark.thoroughfare != nil {
                        addressString = addressString + placemark.thoroughfare! + ", "
                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality! + ", "
                    }
                    if placemark.country != nil {
                        addressString = addressString + placemark.country! + ", "
                    }
                    if placemark.postalCode != nil {
                        addressString = addressString + placemark.postalCode! + " "
                    }
                    print(addressString)
                    self.city = addressString
                }
                else{
                print("No placemarks found.")
            }
        })
    
    }


    public func getZipCode()->String {
        return zipCode ?? ""
    }
   
    public func getCity()->String {
        return self.city ?? ""
    }
    public func getLatLong()->String {
        return  "lat:" + String(newLocation?.coordinate.latitude ?? 2.0) + " " + "long:" + String(newLocation?.coordinate.longitude ?? 0.0)
    }
}


