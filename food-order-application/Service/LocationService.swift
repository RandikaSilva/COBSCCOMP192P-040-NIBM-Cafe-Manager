//
//  LocationService.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-30.
//

import UIKit
import CoreLocation


    
class LocationService: NSObject {
    
    let locationManager = CLLocationManager()
    
    func configure(context:CLLocationManagerDelegate,locationManager:CLLocationManager){
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()

        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
               if let error = error {
                   print("Request Authorization Failed (\(error), \(error.localizedDescription))")
               }
           }

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate=context
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            LocationData.RESTURENTLOCATION.latitude=locationManager.location?.coordinate.latitude ?? 0.0
            LocationData.RESTURENTLOCATION.longitude=locationManager.location?.coordinate.longitude ?? 0.0
            
        }
    }
    
    func getGpsLocation(completion: @escaping (Any)->()){
        let location = CLLocation()
        let currentLoc = locationManager.location
        location.setValue(currentLoc?.coordinate.latitude ?? 0.0, forKey: "latitude")
        location.setValue(currentLoc?.coordinate.longitude ?? 0.0, forKey: "longitude")
        completion(location)
    }
    
    func getResturentLocation()->CLLocation{
        let location = CLLocation(latitude: LocationData.RESTURENTLOCATION.latitude, longitude: LocationData.RESTURENTLOCATION.longitude)
        return location
    }
    
    func calculateDistance(gpsLocation:CLLocation,resturentLocation:CLLocation){
        let distance=gpsLocation.distance(from: resturentLocation) / 1000
        if distance<=10{
            // Customer Coming
            print("Customer Arrived")
            
            
        }else{
            // User still arriving
            print("Customer Still Arriving")
        }
    }
    
}

