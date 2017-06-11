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

    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.0, animations: {
            self.titleLogoLabel.alpha = 1.0
            self.logoImage.alpha = 1.0
        })
    }

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLogoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        titleLogoLabel.alpha = 0.0
        logoImage.alpha = 0.0
        
        //parallax effect in back image
        let min = CGFloat(-20)
        let max = CGFloat(20)
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        backgroundImage.addMotionEffect(motionEffectGroup)
        
        if view.frame.height == 568{
            titleLogoLabel.font = titleLogoLabel.font.withSize(50)
        }
        
        activityIndicator.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        userNameTextField.layer.cornerRadius = userNameTextField.frame.height/2
        userNameTextField.attributedPlaceholder = NSAttributedString(string: userNameTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        userNameTextField.backgroundColor = UIColor.clear
        userNameTextField.layer.borderWidth = 1.2
        userNameTextField.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/2
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.layer.borderWidth = 1.2
        passwordTextField.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.tintColor = UIColor.clear
        loginButton.backgroundColor = UIColor.init(red: 0.0867, green: 0.3861, blue: 0.5000, alpha: 1.0)

        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
        
        UIView.animate(withDuration: 3, delay: 1, options:[UIViewAnimationOptions.allowUserInteraction,UIViewAnimationOptions.repeat,UIViewAnimationOptions.autoreverse], animations: {
            self.loginButton.backgroundColor = self.randomColor()
        }, completion:nil )
        
    }
    var counter = 1
    func randomColor() -> UIColor {
        counter += 1
        if counter % 2 == 0{
            return UIColor.init(red: 0.2437, green: 0.7835, blue: 0.9527, alpha: 1.0)
        }
        else{
            return UIColor.init(red: 0.0867, green: 0.3861, blue: 0.5000, alpha: 1.0)
        }
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        self.view.layoutIfNeeded()
        loginButton.isEnabled = false
        userNameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.activityIndicator.isHidden = false
        })
        FIRAuth.auth()?.signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil{
                self.activityIndicator.isHidden = true
                self.loginButton.isEnabled = true
                self.userNameTextField.isEnabled = true
                self.passwordTextField.isEnabled = true
                print("Login Successfull")
                //Go to the HomeViewController if the login is sucessful
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                self.present(vc!, animated: true, completion: nil)
            }
            else{
                self.activityIndicator.isHidden = true
                self.loginButton.isEnabled = true
                self.userNameTextField.isEnabled = true
                self.passwordTextField.isEnabled = true
                print("Login Unsuccessfull")
                //to initiate alert if login is unsuccesfull
                let alertController = UIAlertController(title: "Try Again", message: "Incorrect username or password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // for tapping
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
