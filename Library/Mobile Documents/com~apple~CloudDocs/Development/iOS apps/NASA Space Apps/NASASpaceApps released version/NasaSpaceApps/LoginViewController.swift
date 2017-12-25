//
//  LoginViewController.swift
//  NasaSpaceApps
//
//  Created by Saransh Mittal on 18/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginAction(_ sender: Any) {
        activityIndicator.startAnimating()
        signupButton.isEnabled = false
        loginButton.isEnabled = false
        if (usernameField.text?.isEmpty)! && (passwordField.text?.isEmpty)!{
            signupButton.isEnabled = true
            loginButton.isEnabled = true
            let alertController = UIAlertController(title: "Fields are empty", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            print("Fields are empty")
            activityIndicator.stopAnimating()
        }
        else{
            print("login action taking place! waiting for backend to respond")
            let header = ["email":usernameField.text!,"password":passwordField.text!]
            Alamofire.request("https://nasaspaceapps.herokuapp.com/auth/login", method: .post, parameters: header).responseJSON{ response in
                if response.result.value == nil{
                    print("found nil value from backend")
                    return
                }
                print(response.result.value!)
                let details = response.result.value as! NSDictionary
                if response.result.isSuccess && String(describing: details["code"]!) == "0"{
                    print("Login successful")
                    token = details["token"] as! String
//                    UserDefaults.standard.set(true, forKey: "Token")
//                    UserDefaults.standard.setValue(token, forKey: "TokenValue")
                    let defaults = UserDefaults.standard
                    defaults.set(token, forKey: "MyKey")
                    defaults.synchronize()
                    self.signupButton.isEnabled = true
                    self.loginButton.isEnabled = true
                    self.activityIndicator.stopAnimating()
                    //Go to the HomeViewController if sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Start")
                    self.present(vc!, animated: true, completion: nil)
                }
                else{
                    print("Login failure")
                    self.signupButton.isEnabled = true
                    self.loginButton.isEnabled = true
                    self.activityIndicator.stopAnimating()
                    let alertController = UIAlertController(title: "Error", message: "Something went wrong! Please try after some time!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(backAction))
        // Do any additional setup after loading the view.
        // for hitting return
        usernameField.delegate = self
        passwordField.delegate = self
        
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        signupButton.layer.cornerRadius = signupButton.frame.height/2
        usernameField.layer.cornerRadius = usernameField.frame.height/2
        passwordField.layer.cornerRadius = passwordField.frame.height/2
        // to change the color of the placeholder
        usernameField.attributedPlaceholder = NSAttributedString(string: usernameField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordField.attributedPlaceholder = NSAttributedString(string: passwordField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        
//        usernameField.layer.borderWidth = 1.2
//        usernameField.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
//        passwordField.layer.borderWidth = 1.2
//        passwordField.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
//        usernameField.backgroundColor = UIColor.init(red: 19, green: 32, blue: 53, alpha: 1.0)
//        passwordField.backgroundColor = UIColor.init(red: 19, green: 32, blue: 53, alpha: 1.0)
//        usernameField.textColor = UIColor.white
//        passwordField.textColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
    }
    
    var keyboard_flag = 0
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboard_flag == 0 {
            return
        }
        keyboard_flag = 0
        let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let duration = userInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        bottomConstraint.constant -= (keyboardHeight-100)
        topConstraint.constant += (40)
        UIView.animate(withDuration: 0.5, animations: {void in
            
            self.view.layoutIfNeeded()
            
        })
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if keyboard_flag != 0 {
            return
        }
        keyboard_flag = 1
        let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let duration = userInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        self.bottomConstraint.constant += (keyboardHeight-100)
        topConstraint.constant -= (40)
        UIView.animate(withDuration: 0.5, animations: {void in
            self.view.layoutIfNeeded()
        })
    }
    
    // for tapping
    func dismissKeyboard() {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    // for hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
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
