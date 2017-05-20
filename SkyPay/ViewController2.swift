//
//  ViewController2.swift
//  SkyPay
//
//  Created by Saransh Mittal on 17/05/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var left: NSLayoutConstraint!
    @IBOutlet weak var right: NSLayoutConstraint!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var centerButton: UIButton!
    
    var constant = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
//        //self.view2.addGestureRecognizer(tap)
        barView.layer.cornerRadius = barView.frame.height/2
    }

    @IBAction func gestureAction(_ sender: Any) {
            if self.constant%2 == 0{
                self.constant += 1
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.2, animations: {
                    self.right.constant = self.view.frame.width/2 - self.barView.frame.height + 10/2
                    self.left.constant = self.view.frame.width/2 - self.barView.frame.height + 10/2
                    self.view.layoutIfNeeded()
                    self.centerButton.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
                    self.view.layoutIfNeeded()
                })
            }
            else{
                self.constant += 1
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.2, animations: {
                    self.right.constant = 10
                    self.left.constant = 10
                    self.view.layoutIfNeeded()
                    self.centerButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI*2))
                    self.view.layoutIfNeeded()
                })
            }
    }
    @IBAction func buttonOne(_ sender: Any) {
        print("one")
    }
    @IBAction func buttonTwo(_ sender: Any) {
        print("two")
    }
    @IBAction func buttonThree(_ sender: Any) {
        print("three")
    }
    @IBAction func buttonFour(_ sender: Any) {
        print("four")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapGesture(){

        
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
