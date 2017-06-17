//
//  sendBitcoinViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 17/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class sendBitcoinViewController: UIViewController {

    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var amountInDollar: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBAction func payAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        // Do any additional setup after loading the view.
        address.layer.cornerRadius = address.frame.height/2
        address.attributedPlaceholder = NSAttributedString(string: address.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        amount.layer.cornerRadius = amount.frame.height/2
        amount.attributedPlaceholder = NSAttributedString(string: amount.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        amountInDollar.layer.cornerRadius = amountInDollar.frame.height/2
        amountInDollar.attributedPlaceholder = NSAttributedString(string: amountInDollar.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        payButton.layer.cornerRadius = payButton.frame.height/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
