//
//  Forecast.swift
//  WeatherInfo
//
//  Created by Younes El Yandouzi on 29/03/2017.
//  Copyright © 2017 Younes El Yandouzi. All rights reserved.
//

import UIKit
import os.log

class Forecast: NSObject {
    
    //MARK: Properties
    var day: Int
    var morn: Int
    var eve: Int
    var night: Int
    var date: Double
    var icon: String
    
    init?(day: Int, morn: Int, eve: Int, night: Int, date: Double, icon: String) {
        // Initialize stored properties.
        self.day = day
        self.morn = morn
        self.eve = eve
        self.night = night
        self.date = date
        self.icon = icon
    }
    
}
