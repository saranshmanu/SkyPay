//
//  tryViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 28/05/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var viewSample: UIView!
    @IBOutlet weak var viewB: UIView!
    
    let code = "wnr8yn32985yn3498yntv983y4nt98y4n598tyne984"
    
//    override func viewDidAppear(_ animated: Bool) {
//        let databaseRef = FIRDatabase.database().reference()
//        databaseRef.child("Posts").queryOrderedByKey().observe(., with: {snap in
//            self.posts.removeAll()
//            databaseRef.child("Posts").queryOrderedByKey().observe(.childAdded, with: {
//                snapshot in
//                let snapshotValue = snapshot.value as? NSDictionary
//                let title = snapshotValue?["title"] as! String
//                let message = snapshotValue?["message"] as! String
//                self.posts.insert(postStruct(title:title,message:message), at: 0)
//                self.tableview.reloadData()
//                
//            })
//            self.tableview.reloadData()
//        })
//    }
    func post(){
        let title = "Title"
        let message = "message"
        let post:[String:AnyObject]=["title": title as AnyObject,"message": message as AnyObject]
        let databaseRef=FIRDatabase.database().reference()
        databaseRef.child("Posts").childByAutoId().setValue(post)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSample.alpha = 0.0
        setupViewsForRippleEffect()
        // Do any additional setup after loading the view.
        viewB.layer.cornerRadius = viewB.frame.height/2
        // For generating qr code
        if self.qrcodeImage == nil {
            if code == "" {
                print("no qr code available")
                return
            }
            let data = code.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            self.qrcodeImage = filter?.outputImage
            self.displayQRCodeImage()
        }
        self.qrCode.alpha = 0.55
    }
    
    var qrcodeImage: CIImage!
    
    // function to clear out the blur QR code
    func displayQRCodeImage() {
        let scaleX = qrCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrCode.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrCode.image = UIImage(ciImage: transformedImage)
        
    }
    func setupViewsForRippleEffect(){
        viewSample.layer.zPosition = 1111
        self.viewSample.layer.cornerRadius = self.viewSample.frame.size.width / 2;
        self.viewSample.clipsToBounds = true
//        self.viewSample.layer.borderColor = UIColor.init(red: 0.0867, green: 0.3861, blue: 0.5000, alpha: 1.0).cgColor
//        self.viewSample.layer.borderWidth = 60.0
        self.viewSample.backgroundColor = UIColor.init(red: 0.0867, green: 0.3861, blue: 0.5000, alpha: 1.0)
        animateRippleEffect()
    }
    func animateRippleEffect(){
        self.viewSample.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.5, animations: {
            self.viewSample.alpha = 1.0
        })
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, delay: 0,options: UIViewAnimationOptions.curveLinear,animations: {
            self.viewSample.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.viewSample.layer.cornerRadius = self.viewSample.frame.height/2
            self.viewSample.alpha = 0.0
        }, completion: {finished in
            self.animateRippleEffect()
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
