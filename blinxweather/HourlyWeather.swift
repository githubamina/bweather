//
//  HourlyWeather.swift
//  blinxweather
//
//  Created by Moo on 19/12/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import Foundation
import CoreLocation

struct HourlyWeather {
    
    let icon: String
    let temperature: Double
    let time: String
    let temperatureCelsius: Int
    
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json: [String: Any], tz: String) throws {
        guard let unixTime = json["time"] as? Int else { throw SerializationError.missing("Time not available")}
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: tz) //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "h a" //Specify your format that you want
        let strTime = dateFormatter.string(from: date)
        guard let temp = json["temperature"] as? Double else { throw SerializationError.missing("Temp is not available")}
        let celsTemp = Int((temp - 32) * 5 / 9)
        
        self.temperatureCelsius = celsTemp
        guard let icon = json["icon"] as? String else { throw SerializationError.missing("Icon is missing")}
        self.icon = icon
        self.temperature = temp
        self.time = strTime
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/71483dc2329e49ad1a65e05b723f61e6/"
    
    static func forecast (withLocation location: CLLocationCoordinate2D, completion: @escaping ([HourlyWeather]) -> ()) {
        
        let lat = String(format: "%f", location.latitude)
        let long = String(format: "%f", location.longitude)
        
        
        let locationString = "\(lat),\(long)"
        let url = basePath + locationString
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[HourlyWeather] = []
            
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        if let timeZone = json["timezone"] as? String {
                            
                            if let hourlyForecasts = json["hourly"] as? [String: Any] {
                                if let hourlyData = hourlyForecasts["data"] as? [[String: Any]] {
                                    for dataPoint in hourlyData {
                                        if let weatherObject = try? HourlyWeather(json: dataPoint, tz: timeZone) {
                                            if forecastArray.count < 24 {
                                                forecastArray.append(weatherObject)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
            }
            
        }
        
        task.resume()
    }
}

