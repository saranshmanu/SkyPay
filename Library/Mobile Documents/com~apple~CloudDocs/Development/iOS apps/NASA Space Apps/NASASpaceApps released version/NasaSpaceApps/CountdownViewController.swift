//
//  CountdownViewController.swift
//  NasaSpaceApps
//
//  Created by Saransh Mittal on 20/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {

    @IBOutlet weak var loaderAnimationView: UIView!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var timeLabelOutlet: UILabel!
    
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    let userCalendar = Calendar.current
    let requestedComponent: Set<Calendar.Component> = [.day,.hour,.minute,.second]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(backAction))
        // Do any additional setup after loading the view, typically from a nib.
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
        timer.fire()
        //loaderAnimationView.layer.cornerRadius = loaderAnimationView.frame.height/2
        //loaderAnimationView.layer.borderColor = UIColor.init(red: 102/255, green: 204/255, blue: 1, alpha: 1.0).cgColor
    }
    
    func printTime()
    {
        dateFormatter.dateFormat = "dd/MM/yy hh:mm:ss"
        let startTime = Date()
        let endTime = dateFormatter.date(from: "24/04/17 08:00:00")
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: endTime!)
        dateLabelOutlet.text = "\(timeDifference.day!)"
        timeLabelOutlet.text = "\(timeDifference.hour!):\(timeDifference.minute!):\(timeDifference.second!)"
        if startTime > endTime!{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController")
            self.present(vc!, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
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
