//
//  ProfileViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 18/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBAction func logoutAction(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPageViewController")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var nameLogoFirstLetter: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var labelToTellTheUserToScanBarcode: UILabel!
    @IBOutlet weak var blockchainAddress: UILabel!
    @IBOutlet weak var walletBalance: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        nameLogoFirstLetter.layer.cornerRadius = nameLogoFirstLetter.frame.height/2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        walletBalance.text = String(balance) + " BTC"
        labelToTellTheUserToScanBarcode.text = "Scan this code to make payments to " + name
        blockchainAddress.text = String(describing: address["address"]!)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // For generating qr code
        var code = String(describing: address["address"])
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
        self.barcodeImage.alpha = 0.7
    }
    var qrcodeImage: CIImage!
    // function to clear out the blur QR code
    func displayQRCodeImage() {
        let scaleX = barcodeImage.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = barcodeImage.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        barcodeImage.image = UIImage(ciImage: transformedImage)
        barcodeImage.contentMode = .scaleAspectFit
        
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
