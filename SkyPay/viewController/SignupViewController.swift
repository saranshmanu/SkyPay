//
//  SignupViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 28/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore

class SignupViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    func alertView(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func editTextFieldView(textField:UITextField, color:UIColor) {
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName : color])
        textField.layer.cornerRadius = textField.frame.height / 2
    }
    
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    func gotoViewController(storyboardIdentifier:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier)
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard)))
    }
 
    override func viewDidAppear(_ animated: Bool) {
        editTextFieldView(textField: usernameTextField, color: UIColor.white)
        editTextFieldView(textField: passwordTextField, color: UIColor.white)
        editTextFieldView(textField: confirmPasswordTextField, color: UIColor.white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        continueButton.isEnabled = false
        if usernameTextField.text != "" &&  passwordTextField.text != "" && confirmPasswordTextField.text != ""{
            if passwordTextField.text == confirmPasswordTextField.text{
                FIRAuth.auth()?.createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error == nil{
                        self.continueButton.isEnabled = true
                        self.gotoViewController(storyboardIdentifier: "LoginPageViewController")
                        self.alertView(title: "Welcome Aboard!", message:"Successfull Authentication")
                    }else{
                        self.continueButton.isEnabled = true
                        self.alertView(title: "Error", message:"Please try again after some time!")
                    }
                }
            }else{
                self.continueButton.isEnabled = true
                self.alertView(title: "Error", message:"Password does not match!")
            }
        }else{
            self.continueButton.isEnabled = true
            self.alertView(title: "Fields Empty", message:"Please enter details to continue with SkyPay")
        }
    }
}
