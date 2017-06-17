//
//  sendBitcoinViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 17/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import AVFoundation

class sendBitcoinViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBAction func payAction(_ sender: Any) {
    }
    @IBOutlet weak var scanAddress: UIButton!
    @IBAction func scanAddressAction(_ sender: Any) {
        scan()
    }
    // for tapping
    func dismissKeyboard() {
        address.resignFirstResponder()
        amount.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendBitcoinViewController.dismissKeyboard)))
        var navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        // Do any additional setup after loading the view.
        address.layer.cornerRadius = 10//address.frame.height/2
        address.attributedPlaceholder = NSAttributedString(string: address.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.init(red: 238/255, green: 212/255, blue: 123/255, alpha: 1.0)])
        amount.layer.cornerRadius = 10//amount.frame.height/2
        amount.attributedPlaceholder = NSAttributedString(string: amount.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.init(red: 238/255, green: 212/255, blue: 123/255, alpha: 1.0)])
        payButton.layer.cornerRadius = payButton.frame.height/2
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
                        self.address.text = result.value
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
