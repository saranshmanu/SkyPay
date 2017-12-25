//
//  ComponentViewController.swift
//  NasaSpaceApps
//
//  Created by Vansh Badkul on 26/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ComponentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let header = ["x-access-token": token]
        Alamofire.request("https://nasaspaceapps.herokuapp.com/component", method: .get, headers: header).responseJSON{
            response in print(response)
            if response.result.isSuccess{
                let details = response.result.value as! NSDictionary
                item = details["itemname"] as! String
                quan = details["quantity"] as! String
                print(item, quan)
             

            

        // Do any additional setup after loading the view.
    }
        }
        let data = ["x-access-token": token,"itemname": item,"quantity":quan] as [String : Any]

                Alamofire.request("https://nasaspaceapps.herokuapp.com/component", method: .post, parameters: data).responseJSON{ response in
            if response.result.value == nil{
                print("found nil value from backend")
                return
            }
            print(response.result.value!)
            let details = response.result.value as! NSDictionary
            if response.result.isSuccess && String(describing: details["code"]!) == "0"{
                print("Request Sent Successfully")
              
                //Go to the HomeViewController if sucessful
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Start")
                self.present(vc!, animated: true, completion: nil)
            }
            else{
                print("Login failure")
                let alertController = UIAlertController(title: "Error", message: "Something went wrong! Please try after some time!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
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
