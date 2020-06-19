//
//  MainViewModel.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class MainViewModel {
    let location = PublishSubject<CLLocation>()
    
    func getLocationName(location: CLLocation, completion: @escaping((String)->())) {
        var locationName = ""
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
            placemarks?.forEach({ (placemark) in
                if let city = placemark.locality, let country = placemark.country {
                    locationName = "\(city), \(country)"
                    completion(locationName)
                }
            })
        }
    }
    
}
