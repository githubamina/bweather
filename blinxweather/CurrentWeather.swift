//
//  CurrentWeather.swift
//  blinxweather
//
//  Created by Moo on 15/12/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import Foundation
import CoreLocation

struct CurrentWeather {
    
    let icon: String
    let temperature: Double
    //let city: String
    let summary: String
    let detailedSummary: String
    let time: Int
    let day: String
    
    let realFeel: Int
    let humidity: String
    let visibility: String
    let pressure: String
    let wind: String
    let uvIndex: Int
    let precipType: String
    let precipProb: Double
    let skinHumidity: Int
    
    let temperatureCelsius: Int
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json: [String: Any], tz: String, detailedSummary: String) throws {
        guard let unixTime = json["time"] as? Int else { throw SerializationError.missing("Time not available")}
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: tz) //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEEE" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        guard let temperature = json["temperature"] as? Double else { throw SerializationError.missing("Temperature is not available")}
        
        let celsTemp = Int((temperature - 32) * 5 / 9)
        
        self.temperatureCelsius = celsTemp
        
        guard let icon = json["icon"] as? String else { throw SerializationError.missing("Icon is missing")}
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("Summary is missing")}
        let detailedSummary = detailedSummary
        guard let rFeel = json["apparentTemperature"] as? Double else { throw SerializationError.missing("Real feel not available")}
        
        let celsTempRF = Int((rFeel - 32) * 5 / 9)
        
        guard let vis = json["visibility"] as? Double else { throw SerializationError.missing("Visibility not available")}
        let visReal = String(Int(vis * 1.60934)) + " km"
        
        guard let pres = json["pressure"] as? Double else { throw SerializationError.missing("Pressure not available")}
        
        
        if let ws = json["windSpeed"] as? Double {
            let wsKM = String(Int(ws * 1.609))
            if ws > 0 {
                if let wb = json["windBearing"] as? Double {
                    let direction: String
                    if (wb > 11.25 && wb < 33.75) {
                        direction = "NNE"
                    } else if (wb >= 33.75 && wb < 56.25) {
                        direction = "NE"
                    } else if (wb >= 56.25 && wb < 78.75) {
                        direction = "ENE"
                    } else if (wb >= 78.78 && wb < 101.25) {
                        direction = "E"
                    } else if (wb >= 101.25 && wb < 123.75) {
                        direction = "ESE"
                    } else if (wb >= 123.75 && wb < 146.25) {
                        direction = "SE"
                    } else if (wb >= 146.25 && wb < 168.75) {
                        direction = "SSE"
                    } else if (wb >= 168.75 && wb < 191.25) {
                        direction = "S"
                    } else if (wb >= 191.25 && wb < 213.75) {
                        direction = "SSW"
                    } else if (wb >= 213.75 && wb < 236.25) {
                        direction = "SW"
                    } else if (wb >= 236.25 && wb < 258.75) {
                        direction = "WSW"
                    } else if (wb >= 258.75 && wb < 281.25) {
                        direction = "W"
                    } else if (wb >= 281.25 && wb < 303.75) {
                        direction = "WNW"
                    } else if (wb >= 303.75 && wb < 326.25) {
                        direction = "NW"
                    } else if (wb >= 326.25 && wb < 348.75) {
                        direction = "NNW"
                    } else if (wb >= 348.75 || wb < 11.25) {
                        direction = "N"
                    } else {
                        direction = ""
                    }
                    self.wind = direction + " " + wsKM + " km/h"
                } else {
                    self.wind = "n/a"
                }
            } else {
                self.wind = "n/a"
            }

        } else {
            self.wind = "n/a"
            
        }
        
        
      
        
         guard let uv = json["uvIndex"] as? Int else { throw SerializationError.missing("UV not available")}
        
    
        

        
      
        
       
        if let pProb = json["precipProbability"] as? Double {
            self.precipProb = pProb
            if pProb > 0 {
                if let pType = json["precipType"] as? String {
                    self.precipType = pType
                } else {
                    self.precipType = "n/a"
                }
            } else {
                self.precipType = "n/a"
            }
            
        }
        else {
            
            self.precipProb = 0.0
            self.precipType = "n/a"
            
            
        }
 
        
       
        
        
      
        
        let press = (String(Int(pres))) + " hpa"
        
        let humidDecimal = json["humidity"] as! Double
        self.skinHumidity = Int(humidDecimal * 100)
        
        
        let humid = String(Int(humidDecimal * 100)) + "%"
        self.icon = icon
        self.temperature = temperature
        self.summary = summary
        self.time = unixTime
        self.detailedSummary = detailedSummary
        self.day = strDate
        self.realFeel = celsTempRF
        self.humidity = humid
        self.visibility = visReal
        self.pressure = press
        
        self.uvIndex = uv
     
      
      
       
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/71483dc2329e49ad1a65e05b723f61e6/"
    
    static func forecast (withLocation location: CLLocationCoordinate2D, completion: @escaping (CurrentWeather?) -> ()) {
        
        let lat = String(format: "%f", location.latitude)
        let long = String(format: "%f", location.longitude)
        
        
        let locationString = "\(lat),\(long)"
        let url = basePath + locationString
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecast: CurrentWeather!
            
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("object seriali")
                        if let hourlyData = json["hourly"] as? [String: Any] {
                            print("minutely acquired")
                            if let dSummary = hourlyData["summary"] as? String {
                        print(dSummary)
                        if let timeZone = json["timezone"] as? String {
                            print(timeZone)
                            if let currentForecast = json["currently"] as? [String: Any] {
                                        if let weatherObject = try? CurrentWeather(json: currentForecast, tz: timeZone, detailedSummary: dSummary) {
                                            forecast = weatherObject
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    
                }
                
                completion(forecast)
            }
            
        }
        
        task.resume()
    }
    
  
}
