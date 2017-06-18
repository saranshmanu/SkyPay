//
//  SignUpViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 14/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import Firebase
import QuartzCore

class MyParser: NSObject, XMLParserDelegate {
    var parser: XMLParser
    var barcodes = [BarcodeData]()
    init(xml: String) {
        parser = XMLParser(data: xml.data(using: String.Encoding.utf8)!)
        super.init()
        parser.delegate = self
    }
    func parseXML() -> [BarcodeData] {
        parser.parse()
        return barcodes
    }
}
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
class SignUpViewController: UIViewController, QRCodeReaderViewControllerDelegate, XMLParserDelegate {
    @IBOutlet weak var tick: UIImageView!
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let currentElement = elementName;
        print(currentElement)
        aadharDict = attributeDict
        aadharDict["email"] = emailTextField.text
        print(aadharDict)
        FIRDatabase.database().reference().child("Users/" + aadharDict["uid"]!).childByAutoId().setValue(aadharDict)
    }
    
    // for tapping
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if scanButton.isHidden == false{
            let alertController = UIAlertController(title: "Please scan your National Identity", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        continueButton.isEnabled = false
        if emailTextField.text != "" && passwordTextField.text != "" && confirmPassTextField.text != ""{
            if passwordTextField.text == confirmPassTextField.text{
                FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error == nil{
                        self.continueButton.isEnabled = true
                        //Go to the HomeViewController if the login is sucessful
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController")
                        self.present(vc!, animated: true, completion: nil)
                        let alertController = UIAlertController(title: "Welcome Aboard!", message: "Successfull Authentication", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        self.continueButton.isEnabled = true
                        let alertController = UIAlertController(title: "Error", message: "Please try again after some time!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            else{
                self.continueButton.isEnabled = true
                let alertController = UIAlertController(title: "Error", message: "Password does not match !", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else{
            self.continueButton.isEnabled = true
            let alertController = UIAlertController(title: "Fields Empty", message: "Please enter authentication details to continue", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func scan(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" && confirmPassTextField.text != ""{
            scanAdhaar()
        }
        else{
            let alertController = UIAlertController(title: "Fields Empty", message: "Please enter authentication details to continue", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        emailTextField.layer.cornerRadius = emailTextField.frame.height/2
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.black])
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/2
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.black])
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        confirmPassTextField.layer.cornerRadius = confirmPassTextField.frame.height/2
        confirmPassTextField.attributedPlaceholder = NSAttributedString(string: confirmPassTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.black])
        confirmPassTextField.layer.borderWidth = 0.5
        confirmPassTextField.layer.borderColor = UIColor.black.cgColor
        scanButton.layer.cornerRadius = scanButton.frame.height/2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard)))
        tick.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        $0.showTorchButton = true
    })
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        scanButton.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.tick.alpha = 1.0
        })
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
    func scanAdhaar() {
        do {
            if try QRCodeReader.supportsMetadataObjectTypes() {
                reader.modalPresentationStyle = .pageSheet
                reader.delegate = self
                reader.completionBlock = { (result: QRCodeReaderResult?) in
                    if let result = result {
                        print("Completion with result: \(result.value) of type \(result.metadataType)")
                        let parser = MyParser(xml: result.value)
                        _ = parser.parseXML()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
