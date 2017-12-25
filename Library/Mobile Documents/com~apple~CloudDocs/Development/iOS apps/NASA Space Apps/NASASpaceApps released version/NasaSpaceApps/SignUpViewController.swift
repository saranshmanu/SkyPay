//
//  SignUpViewController.swift
//  NasaSpaceApps
//
//  Created by Saransh Mittal on 20/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var OrganisationTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var skillSegmentController: UISegmentedControl!

    
    @IBAction func SubmitAction(_ sender: Any) {
        var skill = ""
        if skillSegmentController.selectedSegmentIndex == 0{
            skill = "design"
        }
        else if skillSegmentController.selectedSegmentIndex == 1{
            skill = "technical"
        }
        else if skillSegmentController.selectedSegmentIndex == 2{
            skill = "management"
        }
        else{
        }
        print(skill)
        if (EmailTextField.text?.isEmpty)! && (PasswordTextField.text?.isEmpty)! && (OrganisationTextField.text?.isEmpty)! && (NameTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Fields are empty", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            print("Fields are empty")

        }
        else{
            print("signup taking place! waiting for backend to respond")
            SubmitButton.isEnabled = false
            let header = ["email":EmailTextField.text!,"password":PasswordTextField.text!, "name":NameTextField.text!, "skill":skill, "college" :OrganisationTextField.text!]
            Alamofire.request("https://nasaspaceapps.herokuapp.com/auth/save", method: .post, parameters: header).responseJSON{ response in
                if response.result.value == nil{
                    print("nil value from backend")
                    return
                }
                print(response.result.value)
                let details = response.result.value as! NSDictionary
                if response.result.isSuccess && String(describing: details["code"]!)=="0"{
                    self.SubmitButton.isEnabled = true
                    print("Signup successful")
                    //Go to the HomeViewController if sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController")
                    self.present(vc!, animated: true, completion: nil)
                    //to initiate alert view
                    let alertController = UIAlertController(title: "Successful", message: "Let's get started", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    print("Signup failure")
                    self.SubmitButton.isEnabled = true
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
        OrganisationTextField.attributedPlaceholder = NSAttributedString(string: OrganisationTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        OrganisationTextField.layer.cornerRadius = OrganisationTextField.frame.height/2
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: PasswordTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        PasswordTextField.layer.cornerRadius = PasswordTextField.frame.height/2
        EmailTextField.attributedPlaceholder = NSAttributedString(string: EmailTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        EmailTextField.layer.cornerRadius = EmailTextField.frame.height/2
        NameTextField.attributedPlaceholder = NSAttributedString(string: NameTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        NameTextField.layer.cornerRadius = NameTextField.frame.height/2
        SubmitButton.layer.cornerRadius = SubmitButton.frame.height/2
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // for tapping
    func dismissKeyboard() {
        OrganisationTextField.resignFirstResponder()
        EmailTextField.resignFirstResponder()
        NameTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
    }
    // for hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        OrganisationTextField.resignFirstResponder()
        EmailTextField.resignFirstResponder()
        NameTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        return true
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
