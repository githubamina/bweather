//
//  Weather.swift
//  blinxweather
//
//  Created by Moo on 21/9/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    
    let summary: String
    let icon: String
    let temperature: Double
  
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json: [String: Any]) throws {
        guard let summary = json["summary"] as? String else { throw SerializationError.missing("Summary is not available")}
        guard let icon = json["icon"] as? String else { throw SerializationError.missing("Icon is missing")}
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("Temperature is missing")}
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/853e0090aa3ea5b6df7fbe4fd10a9581/"
    
    static func forecast (withLocation location: CLLocationCoordinate2D, completion: @escaping ([Weather]) -> ()) {
        
        let lat = String(format: "%f", location.latitude)
        let long = String(format: "%f", location.longitude)
        
        
        let locationString = "\(lat),\(long)"
        let url = basePath + locationString
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let dailyForecasts = json["daily"] as? [String: Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String: Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
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
