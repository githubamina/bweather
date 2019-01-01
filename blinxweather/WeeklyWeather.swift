//
//  WeeklyWeather.swift
//  blinxweather
//
//  Created by Moo on 15/12/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import Foundation
import CoreLocation

struct WeeklyWeather {
    
    let icon: String
    let temperatureHigh: Double
    let temperatureLow: Double
    let temperatureCelsiusHigh: Int
    let temperatureCelsiusLow: Int
    let day: String
    let sunsetTime: String
    let sunriseTime: String
    
    let sunrise: Int
    let sunset: Int
    
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
        dateFormatter.dateFormat = "EEEE" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
       
        let sunrise = json["sunriseTime"] as! Int
        self.sunrise = sunrise
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let sunDateFormatter = DateFormatter()
        sunDateFormatter.timeZone = TimeZone(identifier: tz) //Set timezone that you want
        sunDateFormatter.locale = NSLocale.current
        sunDateFormatter.dateFormat = "h:mm a" //Specify your format that you want
        let sunRTime = sunDateFormatter.string(from: sunriseDate)
        self.sunriseTime = sunRTime
        
        

        let sunset = json["sunsetTime"] as! Int
        self.sunset = sunset
            let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunset))
            let sunSTime = sunDateFormatter.string(from: sunsetDate)
             self.sunsetTime = sunSTime
            
    
        guard let tempHigh = json["temperatureHigh"] as? Double else { throw SerializationError.missing("Temp high is not available")}
        let celsTempHigh = Int((tempHigh - 32) * 5 / 9)
        
        self.temperatureCelsiusHigh = celsTempHigh
        guard let icon = json["icon"] as? String else { throw SerializationError.missing("Icon is missing")}
        guard let tempLow = json["temperatureLow"] as? Double else {throw SerializationError.missing("Temperature is missing")}
        let celsTempLow = Int((tempLow - 32) * 5 / 9)
        
        self.temperatureCelsiusLow = celsTempLow
        self.icon = icon
        self.temperatureHigh = tempHigh
        self.temperatureLow = tempLow
        self.day = strDate
        
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/71483dc2329e49ad1a65e05b723f61e6/"
    
    static func forecast (withLocation location: CLLocationCoordinate2D, completion: @escaping ([WeeklyWeather]) -> ()) {
        
        let lat = String(format: "%f", location.latitude)
        let long = String(format: "%f", location.longitude)
        
        
        let locationString = "\(lat),\(long)"
        let url = basePath + locationString
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[WeeklyWeather] = []
            
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        if let timeZone = json["timezone"] as? String {
                     
                        if let dailyForecasts = json["daily"] as? [String: Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String: Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? WeeklyWeather(json: dataPoint, tz: timeZone) {
                                        forecastArray.append(weatherObject)
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
