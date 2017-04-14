//
//  City.swift
//  WeatherInfo
//
//  Created by Younes El Yandouzi on 14/04/2017.
//  Copyright © 2017 Younes El Yandouzi. All rights reserved.
//

import UIKit
import os.log

class City: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var id: Int
    var temp: Int
    var icon: String
    
    //MARK: Types
    struct PropertyKey {
        static let id = "id"
        static let name = "name"
        static let temp = "temp"
        static let icon = "icon"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cities")
    
    init?(id: Int, name: String, temp: Int, icon: String) {
        // Initialize stored properties.
        self.id = id
        self.name = name
        self.temp = temp
        self.icon = icon
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(temp, forKey: PropertyKey.temp)
        aCoder.encode(icon, forKey: PropertyKey.icon)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            return nil
        }
        let temp = aDecoder.decodeInteger(forKey: PropertyKey.temp)
        guard let icon = aDecoder.decodeObject(forKey: PropertyKey.icon) as? String else {
            return nil
        }
        
        // Must call designated initializer.
        self.init(id: id, name: name, temp: temp, icon: icon)
        
    }
    
}


