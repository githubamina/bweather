//
//  ForecastViewController.swift
//  blinxweather
//
//  Created by Moo on 14/12/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces



class ForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
   
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var pipImage: UIImageView!
    @IBOutlet weak var skinSuggestion: UILabel!
    @IBOutlet weak var precipSuggestion: UILabel!
    @IBOutlet weak var uvSuggestion: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var realfeelLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var detailedSummary: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    var pipImage1: UIImage!
    var pipImage2: UIImage!
    var pipImage3: UIImage!
    
    var hotpip1: UIImage!
    var hotpip2: UIImage!
    var hotpip3: UIImage!
    
    var coldpip1: UIImage!
    var coldpip2: UIImage!
    var coldpip3: UIImage!
    
    var excoldpip1: UIImage!
    var excoldpip2: UIImage!
    var excoldpip3: UIImage!
    
    var exhotpip1: UIImage!
    var exhotpip2: UIImage!
    var exhotpip3: UIImage!
    
    var hotPipImages: [UIImage]!
    
    var coldPipImages: [UIImage]!

    var exHotPipImages: [UIImage]!

    var exColdPipImages: [UIImage]!

    var pipImages: [UIImage]!
    
    var pipAnimatedImage: UIImage!
    
    var locationManager = CLLocationManager()
    
    
    var location: CLLocationCoordinate2D!
    
    var forecastData = [WeeklyWeather]()
    
    var hourlyForecastData = [HourlyWeather]()
    
    var currentForecast: CurrentWeather!
    
    var uvIndex: Int!
    
    var precipType: String!
    
    var precipProb: Double!
    
    var skinHumidity: Int!
    
    //var cityName: String
    
    var currentSummary: String!
    
    var currentDetailedSummary: String!
    
    var currentTemp: String!
    
    var todayIcon: String!
    
    var time: Int!
    
    var sunset: Int!
    
    var sunrise: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            tableView.tableFooterView = UIView()
        
        pipImage1 = UIImage(named: "normalpip1")
        pipImage2 = UIImage(named: "normalpip2")
        pipImage3 = UIImage(named: "normalpip1")
        
        hotpip1 = UIImage(named: "hotpip1")
        hotpip2 = UIImage(named: "hotpip2")
        hotpip3 = UIImage(named: "hotpip1")
        
        coldpip1 = UIImage(named: "winterpip1")
        coldpip2 = UIImage(named: "winterpip3")
        coldpip3 = UIImage(named: "winterpip1")
        
        exhotpip1 = UIImage(named: "exhotpip1")
        exhotpip2 = UIImage(named: "exhotpip2")
        exhotpip3 = UIImage(named: "exhotpip1")
        
        excoldpip1 = UIImage(named: "excoldpip1")
        excoldpip2 = UIImage(named: "excoldpip2")
        excoldpip3 = UIImage(named: "excoldpip1")
        
        
        
        
        
        pipImages = [pipImage1, pipImage2, pipImage3]
        
        hotPipImages = [hotpip1, hotpip2, hotpip3]
        
        exHotPipImages = [exhotpip1, exhotpip2, exhotpip3]
        
        exColdPipImages = [excoldpip1, excoldpip2, excoldpip3]
        
        
        coldPipImages = [coldpip1, coldpip2, coldpip3]



        
        
        //pipAnimatedImage = UIImage.animatedImage(with: pipImages, duration: 2.0)
        
        
        if (location != nil) {
            convertLatLongToAddress(loc: location)

            updateWeatherForLocation(location: location)
            updateCurrentForecast(location: location)
            updateHourlyForLocation(location: location)
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.requestWhenInUseAuthorization()
            
            
            if CLLocationManager.locationServicesEnabled() {
                
                locationManager.startUpdatingLocation()
                locationManager.stopUpdatingLocation()
                
            } else {
                    self.performSegue(withIdentifier: "locationErrorSegue", sender: self)
                
            }
        }
        
  
        
        
        
       
        
        
        

        
       

     

        
    }
    
    
    func updateCurrentForecast(location: CLLocationCoordinate2D) {
        CurrentWeather.forecast(withLocation: location, completion: { (results: CurrentWeather?) in
            if let currentData = results {
            self.currentForecast = currentData
                
                self.convertLatLongToAddress(loc: location)

                
                DispatchQueue.main.async {
                    
                    self.currentTempLabel.text = String(self.currentForecast.temperatureCelsius) + "°C"
                    self.summaryLabel.text = self.currentForecast.summary
                    self.detailedSummary.text = self.currentForecast.detailedSummary
                    self.dayLabel.text = self.currentForecast.day
                    self.realfeelLabel.text = String(self.currentForecast.realFeel) + "°C"
                    self.humidityLabel.text = String(self.currentForecast.humidity)
                    self.visibilityLabel.text = String(self.currentForecast.visibility)
                   
                    self.pressureLabel.text = String(self.currentForecast.pressure)
                    self.windLabel.text = String(self.currentForecast.wind)
                    self.todayIcon = (self.currentForecast.icon)
                    self.time = self.currentForecast.time
                    
                    if (self.sunrise != nil) {
                        if (self.time > self.sunset || self.time < self.sunrise) {
                            self.mainScroll.backgroundColor = self.UIColorFromHex(rgbValue: 0x446685,alpha: 1)
                        }
                    }
                   
                    
                    
                    UIView.animate(withDuration: 4, animations: { self.image1.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                     UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 150, y: 200) }, completion: nil)
                    
                    switch (self.todayIcon) {
                    case "cloudy":
                        self.image2.image = UIImage(named: "cloud2")
                        UIView.animate(withDuration: 4, animations: { self.image1.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 150, y: 200) }, completion: nil)
                        break;
                    case "fog":
                        self.image1.isHidden = true

                        self.image2.image = UIImage(named: "fog-3")
                        UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        break;
                    case "sleet":
                        self.image1.isHidden = true

                        self.image2.image = UIImage(named: "sleet-2")
                        UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        break;
                    case "snow":
                        self.image1.isHidden = true

                        self.image2.image = UIImage(named: "snow-2")
                        UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        break;
                    case "rain":
                        self.image1.isHidden = true

                        self.image2.image = UIImage(named: "rain-2")
                        UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        break;
                    case "partly-cloudy-day":
                        //set image
                        if (self.time > self.sunset || self.time < self.sunrise) {
                            self.mainScroll.backgroundColor = self.UIColorFromHex(rgbValue: 0x446685,alpha: 1)
                            self.image2.image = UIImage(named: "moon")
                            UIView.animate(withDuration: 4, animations: { self.image1.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                            UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 150, y: 200) }, completion: nil)
                        } else {
                            self.mainScroll.backgroundColor = UIColor.lightGray
                            self.image2.image = UIImage(named: "sun")
                            UIView.animate(withDuration: 4, animations: { self.image1.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                            UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 150, y: 200) }, completion: nil)
                        }
                        break;
                    case "clear-day":
                        self.image1.isHidden = true

                        if (self.time > self.sunset || self.time < self.sunrise) {
                            self.mainScroll.backgroundColor = self.UIColorFromHex(rgbValue: 0x446685,alpha: 1)
                            self.image2.image = UIImage(named: "moon")
                            UIView.animate(withDuration: 3, animations: { self.image2.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        } else {
                            self.image2.image = UIImage(named: "sun")
                            UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 210, y: 200) }, completion: nil)
                        }
                        break;
                    case "clear-night":
                        self.image1.isHidden = true

                        self.mainScroll.backgroundColor = self.UIColorFromHex(rgbValue: 0x446685,alpha: 1)
                        self.image2.image = UIImage(named: "moon")
                        UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        break;
                    case "partly-cloudy-night":
                        self.mainScroll.backgroundColor = self.UIColorFromHex(rgbValue: 0x446685,alpha: 1)
                        self.image2.image = UIImage(named: "moon")
                        UIView.animate(withDuration: 4, animations: { self.image1.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 150, y: 200) }, completion: nil)
                        break;
                    case "wind":
                        self.image2.image = UIImage(named: "wind-3")
                        self.image1.isHidden = true
                        UIView.animate(withDuration: 2, animations: { self.image2.layer.position = CGPoint(x: 200, y: 200) }, completion: nil)
                        break;
                    default:
                        break;
                    }
                    
                    if (self.currentForecast.temperatureCelsius <= 0) {
                        self.pipImage.animationImages = self.exColdPipImages
                        self.pipImage.animationDuration = 1.0
                        self.pipImage.animationRepeatCount = 1
                        self.pipImage.startAnimating()
                        self.pipImage.image = UIImage(named: "excoldpip1")
                    } else if (self.currentForecast.temperatureCelsius > 0 && self.currentForecast.temperatureCelsius < 20) {
                        self.pipImage.animationImages = self.coldPipImages
                        self.pipImage.animationDuration = 1.0
                        self.pipImage.animationRepeatCount = 1
                        self.pipImage.startAnimating()
                        self.pipImage.image = UIImage(named: "winterpip1")
                        //self.pipImage.stopAnimating()
                    } else if (self.currentForecast.temperatureCelsius > 20 && self.currentForecast.temperatureCelsius < 25) {
                        self.pipImage.animationImages = self.pipImages
                        self.pipImage.animationDuration = 1.0
                        self.pipImage.animationRepeatCount = 1
                        self.pipImage.startAnimating()
                        self.pipImage.image = UIImage(named: "normalpip1")
                        //self.pipImage.stopAnimating()
                    } else if (self.currentForecast.temperatureCelsius > 24 && self.currentForecast.temperatureCelsius < 38) {
                        self.pipImage.animationImages = self.hotPipImages
                        self.pipImage.animationDuration = 1.0
                        self.pipImage.animationRepeatCount = 1
                        self.pipImage.startAnimating()
                        self.pipImage.image = UIImage(named: "hotpip1")
                        //self.pipImage.stopAnimating()
                    } else if (self.currentForecast.temperatureCelsius > 37) {
                        self.pipImage.animationImages = self.exHotPipImages
                        self.pipImage.animationDuration = 1.0
                        self.pipImage.animationRepeatCount = 1
                        self.pipImage.startAnimating()
                        self.pipImage.image = UIImage(named: "exhotpip1")

                        //self.pipImage.stopAnimating()
                    }

                   

                    
                    self.skinHumidity = self.currentForecast.skinHumidity
                    
                    if (self.skinHumidity < 50) {
                        self.skinSuggestion.text = "Humidity is low today. Use stronger, more hydrating products. You might also want to try using a hydrating mist, and lip balm."
                    } else if (self.skinHumidity >= 50) {
                        self.skinSuggestion.text = "Humidity is high today. Use products that are less hydrating + more lightweight, use toner more often, and try using a water-based moisturiser and an oil-based cleanser."
                    }
                    self.uvIndex = self.currentForecast.uvIndex
                    print(self.uvIndex)
                    self.precipType = self.currentForecast.precipType
                    print(self.precipType)
                    
                    self.precipProb = self.currentForecast.precipProb
                    
                    
                   // if (self.precipType != nil && self.precipProb != nil) {
                    if(self.precipProb <= 0){
                        self.precipSuggestion.text = "No chance of precipitation right now."

                    }
                        if (self.precipProb > 0 && self.precipProb < 0.4) {
                            switch (self.precipType) {
                            case "rain":
                                
                                self.precipSuggestion.text = "There is a slight chance of " + self.precipType + " today. If you are going out, you might want to take an umbrella or rain poncho just in case!"
                                break
                            case "snow":
                                self.precipSuggestion.text = "There is a slight chance of " + self.precipType + " today. If you are going out, you might want to take a waterproof jacket just in case!"
                                break
                            case "sleet":
                                self.precipSuggestion.text = "There is a slight chance of " + self.precipType + " today. If you are going out, you might want to take an umbrella or waterproof jacket just in case!"
                                break
                            default:
                                self.precipSuggestion.isHidden = true
                                break
                            }
                            
                        } else if (self.precipProb >= 0.4 && self.precipProb < 0.7) {
                            switch (self.precipType) {
                            case "rain":
                                self.precipSuggestion.text = "There is a good chance of " + self.precipType + " today. You might want to take an umbrella or rain poncho with you if you go out."
                                break;
                            case "snow":
                                self.precipSuggestion.text = "There is a good chance of " + self.precipType + " today. You might want to take a waterproof jacket with you if you go out."
                                break;
                            case "sleet":
                                self.precipSuggestion.text = "There is a good chance of " + self.precipType + " today. You might want to take an umbrella or waterproof jacket with you if you go out."
                                break;
                            default:
                                self.precipSuggestion.isHidden = true
                                break;
                            }
                            
                            
                        } else if (self.precipProb >= 0.7 && self.precipProb < 1) {
                            switch (self.precipType) {
                            case "rain":
                                self.precipSuggestion.text = "There is a high chance of " + self.precipType +  " today. You should take an umbrella or rain poncho with you if you are heading outdoors."
                                break;
                            case "snow":
                                self.precipSuggestion.text = "There is a high chance of " + self.precipType + " today. You should wear waterproof clothing (e.g. jacket and shoes) if you are going outside."
                                break;
                            case "sleet":
                                self.precipSuggestion.text = "There is a high chance of " + self.precipType + " today. You should take an umbrella or waterproof jacket with you if you are heading outside."
                                break
                            default:
                                break
                            }
                            
                        } else if (self.precipProb == 1) {
                            switch (self.precipType) {
                            case "rain":
                                self.precipSuggestion.text = "There is a definite chance of " + self.precipType + " today. You will need an umbrella or rain jacket when going outside."
                                break
                            case "snow":
                                self.precipSuggestion.text = "There is a definite chance of " + self.precipType + " today. You will need waterproof clothing (e.g. jacket and shoes) when going outside."
                                break
                            case "sleet":
                                self.precipSuggestion.text = "There is a definite chance of " + self.precipType + " today. You will need an umbrella or a hooded waterproof jacket when going outside."
                                break
                            default:
                                break;
                            }
                        }
                    //}
                    
                    
                    switch (self.uvIndex!) {
                    case 1, 2:
                        self.uvSuggestion.text = "The UV Index is a low  \(self.uvIndex!)   today. You'll only need sun protection if you're outside for extended periods of time."
                        break;
                    case 3, 4, 5:
                        self.uvSuggestion.text = "The UV Index is a mild  \(self.uvIndex!) today. You may want to wear a hat and sunglasses and apply a light sunscreen throughout the day. Try to stay in the shade around 12pm as this is when UV rays will be strongest."
                        break;
                    case 6, 7:
                        self.uvSuggestion.text = "The UV Index is a high \(self.uvIndex!) today. Try and reduce your sun exposure between 10am and 4pm. Wear a hat, sunglasses, and long sleeves to stay protected. Apply sunscreen every 2 hours."
                        break;
                    case 8, 9, 10:
                        self.uvSuggestion.text = "The UV Index is very high today at \(self.uvIndex!) today. To stay protected, you should wear a hat, sunglasses, and long sleeves, and regularly apply sunscreen every 2 hours. Avoid being outdoors for extended periods, especially between 10am and 4pm."
                        break;
                    case 11, 12, 13, 14, 15, 16:
                        self.uvSuggestion.text = "The UV Index is at an extreme today at \(self.uvIndex!). You must try and avoid sun exposure between 10am and 4pm. Wear a hat, sunglasses and long sleeves, and apply sunscreen every 2 hours. If left unprotected, there is an extreme risk of skin and eyes being damaged."
                        break;
                
                    default:
                        self.uvSuggestion.text = "UV index is currently 0."
                        break;
                        
                    }

                    
                }
            } else {
                self.performSegue(withIdentifier: "forecastSegue", sender: self)

            }
        })
       
    }
   
    
    func updateWeatherForLocation(location: CLLocationCoordinate2D) {
        WeeklyWeather.forecast(withLocation: location, completion: { (results:[WeeklyWeather]?) in
            
            if let weatherData = results {
                self.forecastData = weatherData
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                        self.sunrise = self.forecastData[0].sunrise
                        self.sunriseLabel.text = self.forecastData[0].sunriseTime
                    
                        self.sunset = self.forecastData[0].sunset
                        self.sunsetLabel.text = self.forecastData[0].sunsetTime


                
                }
            } else {
                self.performSegue(withIdentifier: "forecastSegue", sender: self)
                
            }
            
        })
    }
    
    func updateHourlyForLocation(location: CLLocationCoordinate2D) {
        HourlyWeather.forecast(withLocation: location, completion: { (results:[HourlyWeather]?) in
            
            if let weatherData = results {
                self.hourlyForecastData = weatherData
                
                
                DispatchQueue.main.async {
                    self.hourlyCollectionView.reloadData()
                }
            } else {
                self.performSegue(withIdentifier: "forecastSegue", sender: self)
                
            }
            
        })
    }
    
    
    
  


    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeeklyTableViewCell
        
        
        let weatherObject = forecastData[indexPath.section]
        
        cell.tempLowLabel.text = "\(weatherObject.temperatureCelsiusLow)°C"
        cell.tempHighLabel.text = "\(weatherObject.temperatureCelsiusHigh)°C"
        cell.dayLabel.text = weatherObject.day
        cell.weeklyIcon.image = UIImage(named: weatherObject.icon)
        return cell
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = locations[0].coordinate
        location = locValue
        updateWeatherForLocation(location: location)
        updateCurrentForecast(location: location)
        updateHourlyForLocation(location: location)
        convertLatLongToAddress(loc: location)
        print("hellloo")
        print(location)

    }
    
    
    
    //Get location name
    func convertLatLongToAddress(loc: CLLocationCoordinate2D){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            
            if let locality = placeMark.locality {
                self.cityLabel.text = locality
            }
        })
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    

 
    
   
   
}

extension ForecastViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in hourlyCollectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return hourlyForecastData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "hourly", for: indexPath) as? HourlyCollectionViewCell
        
        let weatherObject = hourlyForecastData[indexPath.section]
        
        cell?.time.text = weatherObject.time
        cell?.tempLabel.text = "\(weatherObject.temperatureCelsius) °C"
        cell?.iconView.image = UIImage(named: weatherObject.icon)
        
        cell?.iconView.contentMode = .scaleAspectFit
        
        
        
        return cell!
    }
    
    
}







