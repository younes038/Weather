//
//  ForecastTableViewCell.swift
//  WeatherInfo
//
//  Created by Younes El Yandouzi on 14/04/2017.
//  Copyright © 2017 Younes El Yandouzi. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var morningLbl: UILabel!
    @IBOutlet weak var eveningLbl: UILabel!
    @IBOutlet weak var nightLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
