//
//  LoginViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 28/05/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLogoLabel: UILabel!
    
    func enableControls(){
        self.activityIndicator.isHidden = true
        self.loginButton.isEnabled = true
        self.userNameTextField.isEnabled = true
        self.passwordTextField.isEnabled = true
    }
    
    func disableControls(){
        self.view.layoutIfNeeded()
        loginButton.isEnabled = false
        userNameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.activityIndicator.isHidden = false
        })
    }
    
    func alertView(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gotoViewController(storyboardIdentifier:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier)
        self.present(vc!, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.0, animations: {
            self.titleLogoLabel.alpha = 1.0
            self.logoImage.alpha = 1.0
        })
    }
    
    func addParallaxToBackground(){
        let min = CGFloat(-0)
        let max = CGFloat(0)
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        backgroundImage.addMotionEffect(motionEffectGroup)
    }
    
    func editTextFieldView(textField:UITextField, color:UIColor){
        textField.layer.cornerRadius = textField.frame.height/2
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName : color])
        textField.backgroundColor = UIColor.clear
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = color.cgColor
    }
    
    func editButtonView(button:UIButton){
        button.layer.cornerRadius = button.frame.height/2
        button.tintColor = UIColor.clear
        button.backgroundColor = UIColor.init(red: 0.0867, green: 0.3861, blue: 0.5000, alpha: 1.0)
    }
    
    var counter = 1
    func randomColor() -> UIColor {
        counter += 1
        if counter % 2 == 0{
            return UIColor.init(red: 0.2437, green: 0.7835, blue: 0.9527, alpha: 1.0)
        }else{
            return UIColor.init(red: 0.0867, green: 0.3861, blue: 0.5000, alpha: 1.0)
        }
    }
    
    func addChangeColorAnimationToButton(button:UIButton, delay:TimeInterval, duration:TimeInterval) {
        UIView.animate(withDuration: duration, delay: delay, options:[UIViewAnimationOptions.allowUserInteraction,UIViewAnimationOptions.repeat,UIViewAnimationOptions.autoreverse], animations: {
            button.backgroundColor = self.randomColor()
        }, completion:nil )
    }
    
    func dismissKeyboard() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var initialCenter: CGFloat = 0.0
    var constant:CGFloat = 150.0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.topConstraint.constant -= self.constant
            self.bottomConstraint.constant += self.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(self.userNameTextField.isEditing || self.passwordTextField.isEditing) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.topConstraint.constant += self.constant
                self.bottomConstraint.constant -= self.constant
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        titleLogoLabel.alpha = 0.0
        logoImage.alpha = 0.0
        addParallaxToBackground()
        editTextFieldView(textField: userNameTextField, color: UIColor.white)
        editTextFieldView(textField: passwordTextField, color: UIColor.white)
        editButtonView(button: loginButton)
        addChangeColorAnimationToButton(button: loginButton, delay: 1, duration: 3)
        if view.frame.height == 568{
            titleLogoLabel.font = titleLogoLabel.font.withSize(50)
        }
        activityIndicator.layer.cornerRadius = 10
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        disableControls()
        FIRAuth.auth()?.signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil{
                self.enableControls()
                self.gotoViewController(storyboardIdentifier: "HomeViewController")
            }else{
                self.enableControls()
                self.alertView(title:"Try Again", message:"Incorrect username or password")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
