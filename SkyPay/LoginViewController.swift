//
//  LoginViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 28/05/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate {

    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.0, animations: {
            self.titleLogoLabel.alpha = 1.0
            self.logoImage.alpha = 1.0
        })
    }
    
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
        loginButton.backgroundColor = UIColor.white

        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
        
        UIView.animate(withDuration: 1, delay: 1, options:[UIViewAnimationOptions.allowUserInteraction,UIViewAnimationOptions.repeat,UIViewAnimationOptions.autoreverse], animations: {
            self.backgroundView.backgroundColor = self.randomColor()
            self.backgroundView.backgroundColor = self.randomColor()
        }, completion:nil )
        
    }
    let counter = 1
    func randomColor() -> UIColor {
        if counter % 2 == 0{
            return UIColor.init(red: 0, green: 0, blue: 0, alpha: 1.0)
        }
        else{
            return UIColor.init(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)
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
            }
            else{
                self.activityIndicator.isHidden = true
                self.loginButton.isEnabled = true
                self.userNameTextField.isEnabled = true
                self.passwordTextField.isEnabled = true
                print("Login Unsuccessfull")
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
