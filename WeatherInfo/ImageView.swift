//
//  ImageView.swift
//  WeatherInfo
//
//  Created by Younes El Yandouzi on 14/04/2017.
//  Copyright © 2017 Younes El Yandouzi. All rights reserved.
//

import UIKit

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
