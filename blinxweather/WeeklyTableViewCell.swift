//
//  WeeklyTableViewCell.swift
//  blinxweather
//
//  Created by Moo on 14/12/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {

    @IBOutlet weak var weeklyIcon: UIImageView!
    @IBOutlet weak var tempHighLabel: UILabel!
    @IBOutlet weak var tempLowLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!

    
   
    //Function to convert temperature from farenheit to celsius
    func farenheitToCelsius(fahrenheit: Double) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }

}
