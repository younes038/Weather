//
//  ForecastTableViewController.swift
//  WeatherInfo
//
//  Created by Younes El Yandouzi on 14/04/2017.
//  Copyright © 2017 Younes El Yandouzi. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController, UINavigationControllerDelegate {
    var city: String = ""
    var forecasts = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let urlRequestForecast = URLRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(city.replacingOccurrences(of: " ", with: "%20"))&cnt=16&units=metric&APPID=06ac9b97b6421faecced35fd972b8351")!)
        
        let taskForecast = URLSession.shared.dataTask(with: urlRequestForecast) { (data, response, error) in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    if let list = json["list"] as? [[String: AnyObject]] {
                        var day: Int = 0
                        var morn: Int = 0
                        var eve: Int = 0
                        var night: Int = 0
                        var date: Double = 0
                        var icon: String = ""
                        
                        for i in 0..<list.count {
                            if let dt = list[i]["dt"] as? Double {
                                date = Double(dt)
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
                                icon = licon
                            }
                            
                            let item = Forecast(day: day, morn: morn, eve: eve, night: night, date: date, icon: icon)
                            self.forecasts.append(item!)
                        }
                    }
                    DispatchQueue.main.async {
                        if (json["cod"] as? String == "200") {
                            self.tableView.reloadData()
                        }
                    }
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        taskForecast.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.forecasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as? ForecastTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ForecastTableViewCell.")
        }

        // Configure the cell...
        // Fetches the appropriate meal for the data source layout.
        let forecast = forecasts[indexPath.row]
        
        let df = DateFormatter()
        df.dateFormat = "EEEE, MM/dd/yyyy"
        
        cell.dateLbl.text = "\(df.string(from: NSDate(timeIntervalSince1970: forecast.date) as Date))"
        cell.dayLbl.text = "\(forecast.day)°"
        cell.morningLbl.text = "\(forecast.morn)°"
        cell.eveningLbl.text = "\(forecast.eve)°"
        cell.nightLbl.text = "\(forecast.night)°"
        
        DispatchQueue.main.async {
            cell.imgView.downloadImage(from: "http://openweathermap.org/img/w/\(forecast.icon.description).png")
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInShowMode = presentingViewController is UINavigationController
        
        if isPresentingInShowMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The ForecastTableViewController is not inside a navigation controller.")
        }
    }    

}
