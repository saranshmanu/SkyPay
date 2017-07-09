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

class SignupViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    // for tapping
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: confirmPasswordTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height / 2
        
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        confirmPasswordTextField.layer.cornerRadius = confirmPasswordTextField.frame.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    @IBAction func continueAction(_ sender: Any) {
        continueButton.isEnabled = false
        if usernameTextField.text != "" &&  passwordTextField.text != "" && confirmPasswordTextField.text != ""{
            if passwordTextField.text == confirmPasswordTextField.text{
                FIRAuth.auth()?.createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
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
                let alertController = UIAlertController(title: "Error", message: "Password does not match!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else{
            self.continueButton.isEnabled = true
            let alertController = UIAlertController(title: "Fields Empty", message: "Please enter details to continue with SkyPay", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
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
