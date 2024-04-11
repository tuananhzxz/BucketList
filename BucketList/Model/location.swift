//
//  location.swift
//  BucketList
//
//  Created by tuananhdo on 30/09/2023.
//

import Foundation
import CoreLocation

struct Location : Identifiable, Codable, Equatable {
    var id : UUID
    var name : String
    var description : String
    let latitude : Double
    let longtitude : Double
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude : latitude, longitude : longtitude)
    }
    
    static let newlocation = Location(id: UUID(), name: "New Location", description: "sdsadsa", latitude: 51.505, longtitude: -0.141)
    
    static func ==(lhs : Location, rhs : Location) -> Bool {
        lhs.id == rhs.id
    }
}
