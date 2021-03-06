//
//  OpenWeatherService.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 20.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import CoreLocation

public enum ServerResult<Success, Failure>{
    case success(Success)
    case failure(Failure)
}

public class APIProvider {
    
    public static var shared: APIProvider {
        let service = APIProvider()
        return service
    }
    
    let disposeBag = DisposeBag()
    
    private init() {    }
    
    public func getOneCallForecast(location: CLLocation, completion: @escaping ((ServerResult<OneCallForecast,Void>)->())) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&%20exclude=daily&appid=\(Settings.shared.openWeatherAPIKey)") else {return}
        AF.request(url, method: .get).responseDecodable(of: OneCallForecast.self) { (response) in
//            print("response: \(response)")
            switch response.result {
            case .success(let forecast):
                completion(.success(forecast))
                break
            case .failure(_):
                completion(.failure(()))
                break
            }
        }
    }
    
    public func getCurrentForecast(location: CLLocation, completion: @escaping ((ServerResult<Forecast,Void>)->())) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(Settings.shared.openWeatherAPIKey)") else {return}
        AF.request(url, method: .get).responseDecodable(of: Forecast.self) { (response) in
            switch response.result {
            case .success(let forecast):
                forecast.forecastType = "today"
                completion(.success(forecast))
                break
            case .failure(_):
                completion(.failure(()))
                break
            }
        }
    }
    
    public func loadForecastIcon(iconName: String, completion: @escaping((ServerResult<Data,Void>)->())) {
        guard let url = URL(string: "http://openweathermap.org/img/w/\(iconName).png") else {return}
        AF.request(url).responseData { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                break
            case .failure(_):
                completion(.failure(()))
                break
            }
        }
    }
    
}
