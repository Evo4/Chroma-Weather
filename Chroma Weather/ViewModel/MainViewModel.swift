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
    let currentForecast = PublishSubject<CurrentForecast>()
    
    func getLocationName()->Observable<String> {
        return Observable.create { (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self.location.asObserver().subscribe(onNext: { (location) in
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
                    placemarks?.forEach({ (placemark) in
                        if let city = placemark.locality, let country = placemark.country {
                            let locationName = "\(city), \(country)"
                            Settings.shared.serializeLocationName(of: locationName)
                            observable.onNext(locationName)
                        }
                    })
                }
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }

    
}
