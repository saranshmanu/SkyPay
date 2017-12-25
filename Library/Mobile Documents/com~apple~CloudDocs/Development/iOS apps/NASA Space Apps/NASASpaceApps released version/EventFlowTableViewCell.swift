//
//  EventFlowTableViewCell.swift
//  NasaSpaceApps
//
//  Created by Saransh Mittal on 17/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class EventFlowTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var timing: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
