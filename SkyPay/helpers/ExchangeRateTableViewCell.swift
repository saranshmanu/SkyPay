//
//  ExchangeRateTableViewCell.swift
//  
//
//  Created by Saransh Mittal on 11/06/17.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {

    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countryFlagImageView.layer.cornerRadius = countryFlagImageView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
