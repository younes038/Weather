//
//  APIService.swift
//  WeatherInfo
//
//  Created by Younes El Yandouzi on 13/04/2017.
//  Copyright © 2017 Younes El Yandouzi. All rights reserved.
//

import Foundation

class APIService {
    let baseURL = "http://api.openweathermap.org/data/2.5"
    let APPID = "06ac9b97b6421faecced35fd972b8351"
    
    // MARK: Properties
    
    var code: Int!
    var city: String!
    var degree: Int!
    var imgURL: String!
    
    func getWeather(city: String) {
        let urlRequest = URLRequest(url: URL(string: "\(self.baseURL)/weather?q=\(city.replacingOccurrences(of: " ", with: "%20"))&units=metric&APPID=\(self.APPID)")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                do {
                    /*guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                        return json
                    }*/
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func getForecast(city: String) {
        let urlRequest = URLRequest(url: URL(string: "\(self.baseURL)/forecast/daily?q=\(city.replacingOccurrences(of: " ", with: "%20"))&cnt=16&units=metric&APPID=\(self.APPID)")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                do {
                    
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        task.resume()
    }
}






/*
 //
 //  ViewController.swift
 //  WeatherInfo
 //
 //  Created by Younes El Yandouzi on 29/03/2017.
 //  Copyright © 2017 Younes El Yandouzi. All rights reserved.
 //
 
 import UIKit
 
 class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
 @IBOutlet weak var searchBar: UISearchBar!
 @IBOutlet weak var cityLbl: UILabel!
 @IBOutlet weak var tempLbl: UILabel!
 @IBOutlet weak var imgView: UIImageView!
 
 //MARK: Properties
 var code: Int!
 var city: String!
 var degree: Int!
 var imgURL: String!
 var forecast = [Forecast]()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 // Do any additional setup after loading the view, typically from a nib.
 self.cityLbl.isHidden = true
 self.tempLbl.isHidden = true
 self.imgView.isHidden = true
 self.searchBar.delegate = self
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 let urlRequest = URLRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))&units=metric&APPID=06ac9b97b6421faecced35fd972b8351")!)
 
 let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
 if error == nil {
 do {
 let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
 
 if let weather = json["weather"] as? [[String: AnyObject]] {
 if let icon = weather.first?["icon"] as? String {
 self.imgURL = "http://openweathermap.org/img/w/\(icon).png"
 }
 }
 
 if let current = json["main"] as? [String: AnyObject] {
 if let temp = current["temp"] as? Int {
 self.degree = Int(temp)
 }
 }
 
 if let city = json["name"] as? String {
 self.city = city
 }
 
 if let code = json["id"] as? Int {
 self.code = code
 }
 
 DispatchQueue.main.async {
 if json["cod"] as? Int == 200 {
 self.cityLbl.isHidden = false
 self.tempLbl.isHidden = false
 self.imgView.isHidden = false
 self.cityLbl.text     = self.city
 self.tempLbl.text     = "\(self.degree.description)°"
 self.imgView.downloadImage(from: self.imgURL)
 } else {
 self.cityLbl.isHidden = true
 self.tempLbl.isHidden = true
 self.imgView.isHidden = true
 self.cityLbl.text     = "Pas de ville correspondante trouvée!"
 }
 }
 /*
 let urlRequestForecast = URLRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20")),\(self.code)&cnt=16&units=metric&APPID=06ac9b97b6421faecced35fd972b8351")!)
 
 let taskForecast = URLSession.shared.dataTask(with: urlRequestForecast) { (data, response, error) in
 if error == nil {
 do {
 let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
 
 if let list = json["list"] as? [[String: AnyObject]] {
 var day: Int
 var morn: Int
 var eve: Int
 var night: Int
 var date: Int
 var icon: UIImage
 
 for i in 0..<list.count {
 if let dt = list[i]["dt"] as? Int {
 date = Int(dt)
 }
 if let temp = list.first?["temp"] as? [String: AnyObject] {
 if let lday = temp["day"] as? Int {
 day = Int(lday)
 }
 if let lmorn = temp["morn"] as? Int {
 morn = Int(lmorn)
 }
 if let leve = temp["eve"] as? Int {
 eve = Int(leve)
 }
 if let lnight = temp["night"] as? Int {
 night = Int(lnight)
 }
 }
 if let licon = list.first?["icon"] as? String {
 DispatchQueue.main.async {
 if json["cod"] as? Int == 200 {
 icon = self.imgView.downloadImage(from: "http://openweathermap.org/img/w/\(licon).png") as! UIImage
 } else {
 
 }
 }
 }
 
 let item = Forecast(day: day, morn: morn, eve: eve, night: night, date: date, icon: icon)
 self.forecast.append(item!)
 }
 }
 
 DispatchQueue.main.async {
 if json["cod"] as? Int == 200 {
 
 } else {
 
 }
 }
 } catch let jsonError {
 print(jsonError.localizedDescription)
 }
 }
 }
 taskForecast.resume()*/
 } catch let jsonError {
 print(jsonError.localizedDescription)
 }
 }
 }
 task.resume()
 }
 
 }
 
 extension UIImageView {
 
 func downloadImage(from url: String) {
 let urlRequest = URLRequest(url: URL(string: url)!)
 
 let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
 if error == nil {
 DispatchQueue.main.async {
 self.image = UIImage(data: data!)
 }
 }
 }
 task.resume()
 }
 }
 */
