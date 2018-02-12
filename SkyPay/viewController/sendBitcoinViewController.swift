//
//  sendBitcoinViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 17/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import AVFoundation
import WVCheckMark
import Alamofire
import LocalAuthentication

class sendBitcoinViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var informationPanelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentStatus: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var PaymentAddress: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var loader: UIVisualEffectView!
    
    @IBAction func payAction(_ sender: Any) {
        fingerprintAuthentication()
    }
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var scanAddress: UIButton!
    
    func payment(){
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.paymentSuccess()
        }
    }
    
    func paymentSuccess() {
        paymentStatus.isHidden = false
        checkMark.isHidden = false
        paymentStatus.text = "SUCCESS"
        logoImage.isHidden = true
        viewSample.isHidden = true
        mapImageView.isHidden = true
        checkMark.setColor(color: UIColor.init(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0).cgColor)
        checkMark.setDuration(speed: 1.5)
        checkMark.start()
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            UIView.animate(withDuration: 0.4, animations: {
                self.informationPanelHeightConstraint.constant = self.informationPanelHeightConstraint.constant + 50
                self.loader.alpha = 0.0
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func paymentFailure(){
        paymentStatus.isHidden = false
        checkMark.isHidden = false
        paymentStatus.text = "FAILURE"
        logoImage.isHidden = true
        viewSample.isHidden = true
        mapImageView.isHidden = true
        checkMark.setColor(color: UIColor.init(red: 174/255, green: 34/255, blue: 34/255, alpha: 1.0).cgColor)
        checkMark.setDuration(speed: 1.5)
        checkMark.startX()
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            UIView.animate(withDuration: 0.4, animations: {
                self.informationPanelHeightConstraint.constant = self.informationPanelHeightConstraint.constant + 50
                self.loader.alpha = 0.0
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func scanAddressAction(_ sender: Any) {
        scan()
    }
    
    // for tapping
    func dismissKeyboard() {
        PaymentAddress.resignFirstResponder()
        amount.resignFirstResponder()
    }
    
    //for activation of finger print authentication this function is used along with notify function
    func fingerprintAuthentication(){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,error: &error){
                // Device can use TouchID
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,localizedReason: "Access requires authentication",reply: {(success, error) in
                        DispatchQueue.main.async {
                            if error != nil {
                                switch error!._code {
                                case LAError.Code.systemCancel.rawValue:self.notifyUser("Session cancelled",err: error?.localizedDescription)
                                case LAError.Code.userCancel.rawValue:self.notifyUser("Please try again",err: error?.localizedDescription)
                                case LAError.Code.userFallback.rawValue:self.notifyUser("Authentication",err: "Success")
                                // Custom code to obtain password here
                                default:self.notifyUser("Authentication failed",err: error?.localizedDescription)
                                }
                            }
                            else {
                                //If Authentication is successfull then payment is carried forward
                                self.viewSample.reloadInputViews()
                                self.logoImage.isHidden = false
                                self.viewSample.isHidden = false
                                self.mapImageView.isHidden = false
                                self.paymentStatus.isHidden = true
                                self.checkMark.isHidden = true
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.informationPanelHeightConstraint.constant = self.informationPanelHeightConstraint.constant - 50
                                    self.loader.isHidden = false
                                    self.loader.alpha = 1.0
                                    self.view.layoutIfNeeded()
                                })
                                self.navigationController?.setNavigationBarHidden(true, animated: true)
                                self.setupViewsForRippleEffect()
                                self.payment()
                            }
                        }
                })
        }
        else {
                // Device cannot use TouchID
        }
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,message: err,preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true,completion: nil)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if !UIAccessibilityIsReduceTransparencyEnabled() {
//            backgroundView.backgroundColor = UIColor.clear
//            let blurEffect = UIBlurEffect(style: .dark)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = self.view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            backgroundView.insertSubview(blurEffectView, at: 0)//if you have more UIViews, use an insertSubview API to place it where needed
//            backgroundView.layoutSubviews()
//        } else {
//            self.backgroundView.backgroundColor = UIColor.black
//        }
//    }
    
    @IBOutlet weak var viewSample: UIView!
    @IBOutlet weak var checkMark: WVCheckMark!
    
    func setupViewsForRippleEffect(){
        viewSample.layer.zPosition = 1111
        self.viewSample.layer.cornerRadius = self.viewSample.frame.size.width / 2;
        self.viewSample.clipsToBounds = true
        self.viewSample.backgroundColor = UIColor.init(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.5)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletBalance.text = String(describing: balance) + " BTC"
        loader.isHidden = true
        loader.alpha = 0.0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendBitcoinViewController.dismissKeyboard)))
        var navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        // Do any additional setup after loading the view.
        PaymentAddress.layer.cornerRadius = 10//address.frame.height/2
        PaymentAddress.attributedPlaceholder = NSAttributedString(string: PaymentAddress.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        amount.layer.cornerRadius = 10//amount.frame.height/2
        amount.attributedPlaceholder = NSAttributedString(string: amount.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        payButton.layer.cornerRadius = payButton.frame.height/2
        scanAddress.layer.cornerRadius = 10
    }
    lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        $0.showTorchButton = true
    })
    
    // MARK: - QRCodeReader Delegate Methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    func scan() {
        do {
            if try QRCodeReader.supportsMetadataObjectTypes() {
                reader.modalPresentationStyle = .pageSheet
                reader.delegate = self
                reader.completionBlock = { (result: QRCodeReaderResult?) in
                    if let result = result {
                        print("Completion with result: \(result.value) of type \(result.metadataType)")
                        self.PaymentAddress.text = result.value
                    }
                }
                present(reader, animated: true, completion: nil)
            }
        } catch let error as NSError {
            switch error.code {
            case -11852:
                let alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            case -11814:
                let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            default:()
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
