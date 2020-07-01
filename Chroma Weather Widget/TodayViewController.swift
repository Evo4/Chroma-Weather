//
//  TodayViewController.swift
//  Chroma Weather Widget
//
//  Created by Vyacheslav on 30.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherAPIKit
import RealmSwift
import CoreLocation
import RxCocoa
import RxSwift

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherCityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    
    let todayViewModel = TodayViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performUpdate()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        performUpdate()
        completionHandler(NCUpdateResult.newData)
    }
    
    fileprivate func setupAppGroupsRealm() {
        //setup app groups realm
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.app.Chroma-Weather")!
            .appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: fileURL)
        let appGroupsRealm = try! Realm(configuration: config)
        
        let realmLocation = appGroupsRealm.objects(RealmLocation.self)[0]
        let location = CLLocation(latitude: realmLocation.latitude, longitude: realmLocation.longitude)
        
        todayViewModel.location.onNext(location)
    }
    
    fileprivate func performUpdate() {
        setupAppGroupsRealm()
        
        todayViewModel.locationName
            .observeOn(MainScheduler.instance)
            .bind(to: weatherCityLabel.rx.text)
            .disposed(by: disposeBag)
        
        todayViewModel.description
            .observeOn(MainScheduler.instance)
            .bind(to: weatherDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        todayViewModel.weatherIcon
            .observeOn(MainScheduler.instance)
            .map {
                return UIImage(data: $0)
            }.bind(to: weatherImageView.rx.image)
            .disposed(by: disposeBag)
        
        todayViewModel.currentTemperature
            .observeOn(MainScheduler.instance)
            .bind(to: currentTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        todayViewModel.maxTemperature
            .observeOn(MainScheduler.instance)
            .bind(to: maxTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        todayViewModel.minTemperature
            .observeOn(MainScheduler.instance)
            .bind(to: minTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
