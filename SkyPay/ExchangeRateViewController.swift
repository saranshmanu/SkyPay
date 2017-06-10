//
//  ExchangeRateViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 11/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class ExchangeRateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRates.count
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExchangeRateTableView.dequeueReusableCell(withIdentifier: "ExchangeRateTableView", for: indexPath as IndexPath) as! ExchangeRateTableViewCell
        cell.currencyNameLabel.text = exchangeRates[indexPath.row]["name"] as? String
        cell.exchangeRateLabel.text = String(describing: exchangeRates[indexPath.row]["rate"]!) + " " + String(describing: exchangeRates[indexPath.row]["code"]!)
        return cell
    }
    
    

    @IBOutlet weak var CountryFlagImageView: UIImageView!
    @IBOutlet weak var ExchangeRateTableView: UITableView!
    
    let url = "https://bitpay.com/api/rates/"
    var exchangeRates = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ExchangeRateTableView.delegate = self
        ExchangeRateTableView.dataSource = self
        Alamofire.request(url).responseJSON{
            response in print(response.result.value!)
            if response.result.isSuccess{
                self.exchangeRates = response.result.value! as! [NSDictionary]
                print(self.exchangeRates)
                self.ExchangeRateTableView.reloadData()
            }
        }
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
