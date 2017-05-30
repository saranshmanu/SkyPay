//
//  tryViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 28/05/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class tryViewController: UIViewController {

    @IBOutlet weak var viewSample: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsForRippleEffect()
        // Do any additional setup after loading the view.
    }
    func setupViewsForRippleEffect(){
        viewSample.layer.zPosition = 1111
        self.viewSample.layer.cornerRadius = self.viewSample.frame.size.width / 2;
        self.viewSample.clipsToBounds = true
        //self.viewSample.layer.borderColor = UIColor.blue.cgColor//(rgb: 0x3B5998).CGColor
        //self.viewSample.layer.borderWidth = 2.0
        animateRippleEffect()
    }
    func animateRippleEffect(){
        //animationCounter++
        self.viewSample.alpha = 0.0
        self.viewSample.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 1.5, animations: {
            self.viewSample.alpha = 1.0
        })
        UIView.animate(withDuration: 3.5, delay: 0,options: UIViewAnimationOptions.curveLinear,animations: {
            self.view.layoutIfNeeded()
            self.viewSample.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.viewSample.layer.cornerRadius = 0
        }, completion: {finished in
            //self.animateRippleEffect()
        })
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
