 //
 //  ViewController.swift
 //  WeatherInfo
 //
 //  Created by Younes El Yandouzi on 29/03/2017.
 //  Copyright © 2017 Younes El Yandouzi. All rights reserved.
 //
 
 import UIKit
 import os.log
 
class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var favCities: UITableView!
    @IBOutlet weak var addCity: UIButton!
    @IBOutlet weak var btnForecast: UIButton!
    
    //MARK: Properties
    var code: Int!
    var name: String!
    var temp: Int!
    var icon: String!
    var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.searchBar.delegate = self
        self.favCities.delegate = self
        self.favCities.dataSource = self
        self.searchView.isHidden = true
        
        if let savedCities = loadCities() {
            cities += savedCities
        }
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
                            self.icon = icon
                        }
                    }
                    
                    if let current = json["main"] as? [String: AnyObject] {
                        if let temp = current["temp"] as? Int {
                            self.temp = Int(temp)
                        }
                    }
                    
                    if let name = json["name"] as? String {
                        self.name = name
                    }
                    
                    if let code = json["id"] as? Int {
                        self.code = code
                    }
                    
                    DispatchQueue.main.async {
                        if json["cod"] as? Int == 200 {
                            self.searchView.isHidden = false
                            
                            self.cityLbl.text = self.name
                            self.tempLbl.text = "\(self.temp.description)°"
                            self.imgView.downloadImage(from: "http://openweathermap.org/img/w/\(self.icon.description).png")
                        } else {
                            self.searchView.isHidden = true
                            self.cityLbl.text = "Pas de ville correspondante trouvée!"
                        }
                    }
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cell: CityTableViewCell = (favCities.dequeueReusableCell(withIdentifier: "CityTableViewCell")! as? CityTableViewCell)!
        
        
        // Configure the cell...
        // Fetches the appropriate meal for the data source layout.
        let city = cities[indexPath.row]
        
        cell.imgView.downloadImage(from: "http://openweathermap.org/img/w/\(city.icon.description).png")
        cell.cityLbl.text = city.name
        cell.tempLbl.text = "\(city.temp)°"
        cell.accessoryType = .disclosureIndicator
            
        return cell
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cities.remove(at: indexPath.row)
            // Save the cities.
            saveCities()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "SeeForecast":
            guard let cityDetailViewController = segue.destination as? ForecastTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            cityDetailViewController.city = self.name
            
        case "ShowForecast":
            guard let cityDetailViewController = segue.destination as? ForecastTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCityCell = sender as? CityTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = self.favCities.indexPath(for: selectedCityCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCity = cities[indexPath.row]
            cityDetailViewController.city = selectedCity.name
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    private func saveCities() {
        NSKeyedArchiver.archiveRootObject(cities, toFile: City.ArchiveURL.path)
    }
    
    private func loadCities() -> [City]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: City.ArchiveURL.path) as? [City]
    }
    
    @IBAction func addCity(_ sender: Any) {
        let item = City(id: self.code, name: self.name, temp: self.temp, icon: self.icon)
        self.cities.append(item!)
        self.saveCities()
        self.favCities.reloadData()
    }
    
    @IBAction func btnforecast(_ sender: UIButton) {
        
    }
}

 
