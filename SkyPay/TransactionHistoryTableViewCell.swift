//
//  TransactionHistoryTableViewCell.swift
//  SkyPay
//
//  Created by Saransh Mittal on 17/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class TransactionHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionType: UIImageView!
    @IBOutlet weak var dateOfTransaction: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var amount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
