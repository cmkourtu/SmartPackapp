//
//  locationController.swift
//  SmartPack2
//
//  Created by Craig Kourtu on 4/13/16.
//  Copyright © 2016 ECE477Team1. All rights reserved.
//

import Foundation
import CoreLocation



class CoreLocationController : NSObject, CLLocationManagerDelegate {



    var locationManager:CLLocationManager = CLLocationManager()
   
    

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 1
        
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            print(".NotDetermined")
            break
            
        case .Authorized:
            print(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
            
        case .Denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                           didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        print("updatedLocation")
        print(location)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
            if e != nil {
                print(e!.localizedDescription)
            } else {
                let placemark = placemarks!.last! as CLPlacemark
                
                let userInfo = [
                    "city":     placemark.locality!,
                    "state":    placemark.administrativeArea!,
                    "country":  placemark.country!,
                    "placemark": placemark,
                    "location": location
                ]
                
                
                
                
                
                NSNotificationCenter.defaultCenter().postNotificationName("LOCATION_AVAILABLE", object: nil, userInfo: userInfo)                
            //    print("Printing UserInfo")
            //    print(userInfo)
                
            }
        })
    }
    
    
    
    

}