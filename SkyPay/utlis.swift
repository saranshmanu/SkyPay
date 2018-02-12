//
//  utlis.swift
//  SkyPay
//
//  Created by Saransh Mittal on 12/02/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import Foundation
import QuartzCore

class SegueFromLeft: UIStoryboardSegue{
    override func perform(){
        let src = self.source
        let dst = self.destination
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        UIView.animate(withDuration: 0.25,delay: 0.0,options: UIViewAnimationOptions.curveEaseInOut,animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },completion: { finished in
            src.present(dst, animated: false, completion: nil)
        })
    }
}
