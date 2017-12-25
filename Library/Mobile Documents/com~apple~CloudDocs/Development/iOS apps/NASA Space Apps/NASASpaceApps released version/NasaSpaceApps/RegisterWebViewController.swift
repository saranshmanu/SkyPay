//
//  RegisterWebViewController.swift
//  NasaSpaceApps
//
//  Created by Vansh Badkul on 12/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class RegisterWebViewController: UIViewController {
    
    @IBOutlet weak var RegisterLink: UIWebView!


    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the vie
        let url=URL(string: "")
        
        RegisterLink.loadRequest(URLRequest(url:url!))
        
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
