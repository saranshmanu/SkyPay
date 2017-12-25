//
//  ProfileViewController.swift
//  NasaSpaceApps
//
//  Created by Saransh Mittal on 23/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "MyKey")
        defaults.synchronize()

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartingViewCotroller")
        self.present(vc!, animated: true, completion: nil)
    }
    @IBOutlet weak var organisation: UILabel!
    @IBOutlet weak var workType: UILabel!
    @IBOutlet weak var name: UILabel!
    var qrcodeImage: CIImage!
    @IBOutlet weak var qrCode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let header = ["x-access-token": token]
        Alamofire.request("https://nasaspaceapps.herokuapp.com/profile", method: .get, headers: header).responseJSON{
            response in print(response)
            if response.result.isSuccess{
                let details = response.result.value as! NSDictionary
                nameParticipant = details["name"] as! String
                skill = details["skill"] as! String
                activationToken = details["activation_token"] as! String
                college = details["college"] as! String
                print(nameParticipant, skill, activationToken, college)
                self.name.text = nameParticipant
                self.workType.text = skill
                self.organisation.text = college
                // For generating qr code
                if self.qrcodeImage == nil {
//                    if code == "" {
//                        print("no qr code available")
//                        return
//                    }
                    let data = activationToken.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
                    let filter = CIFilter(name: "CIQRCodeGenerator")
                    filter?.setValue(data, forKey: "inputMessage")
                    filter?.setValue("Q", forKey: "inputCorrectionLevel")
                    self.qrcodeImage = filter?.outputImage
                    self.displayQRCodeImage()
                }
                self.qrCode.alpha = 0.55
            }
        }
    }
    // function to clear out the blur QR code
    func displayQRCodeImage() {
        let scaleX = qrCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrCode.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrCode.image = UIImage(ciImage: transformedImage)
        
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
