//
//  Constants.swift
//  Ramotion Paper OnBoard
//
//  Created by Saransh Mittal on 24/03/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum Asset: String {
        case logo = "logo"
        case Banks = ""
        case ready = "ready"
        case Key = "Key"
        case Shopping_Cart = "Shopping-cart"
        case Stores = "Stores"
        case Wallet = "Wallet"
        case Ins = "ins"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
let blue = UIColor.init(red: 19/255, green: 32/255, blue: 53/255, alpha: 1.0)
var token = ""
var nameParticipant = ""
var skill = ""
var college = ""
var activationToken = ""
var item=""
var quan=""
var prof = UIImage()
