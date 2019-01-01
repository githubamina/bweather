//
//  ViewController.swift
//  blinxweather
//
//  Created by Moo on 22/9/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
  
    
    

    var locationManager = CLLocationManager()
    
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var location: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
     
    }
    
    /**Prepare segue to select forecast screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherSegue" {
            let navController = segue.destination as! UINavigationController
             let destinationController = navController.topViewController as! WeatherTableViewController
            destinationController.location = location
        }
    }
 **/
    
    //Prepare segue to select forecast screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forecastSegue" {
            let navController = segue.destination as! UINavigationController
            let destinationController = navController.topViewController as! ForecastViewController
            destinationController.location = location
        }
    }
}

// Handle the user's selection.
extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        location = place.coordinate
        performSegue(withIdentifier: "forecastSegue", sender: self)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
  
}



