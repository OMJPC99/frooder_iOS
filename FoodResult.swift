//
//  FoodResult.swift
//  First App
//
//  Created by Theodore Ando on 12/7/16.
//  Copyright © 2016 Theodore Ando. All rights reserved.
//

import UIKit
import CoreLocation

class FoodResult: NSObject {
    var emailText: String
    var longitude: Float
    var latitude: Float
    var locationName: String
    
    init(data : NSDictionary) throws {
        if let body = data["body"] as? String {
            emailText = body
        } else {
            throw FoodResultError.emptyBody
        }
    
        if let building_name = data["building_name"] as? String {
            locationName = building_name
        } else {
            throw FoodResultError.emptyLocationName
        }
        
        if let lat = data["lat"] as? Float, let lng = data["lng"] as? Float {
            latitude = lat
            longitude = lng
        } else {
            throw FoodResultError.emptyCoords
        }
    
    }
    
    func dist(manager: CLLocationManager) -> CLLocationDistance {
        let gps = manager.location?.coordinate
        let currentLat = gps?.latitude
        let currentLong = gps?.longitude
        let currentLocation = CLLocation(latitude: currentLat!, longitude: currentLong!)
        let distance = currentLocation.distance(from: CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude)))
        return distance
        
    }
    
    enum FoodResultError: Error {
        case emptyBody
        case emptyLocationName
        case emptyCoords
    }
}
