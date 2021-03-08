//
//  SignUpViewController.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit
import CTKFlagPhoneNumber
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpBtn: UIButton!
    
    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var phoneNumberTf: CTKFlagPhoneNumberTextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var confirmTf: UITextField!
    
    var email: String = ""
    var phoneNumber: String = ""
    var password: String = ""
    var confirm: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initButton()
        emailTf.delegate = self
        phoneNumberTf.delegate = self
        passwordTf.delegate = self
        confirmTf.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        self.registerAccount()
    }
    
    func registerAccount() {
        if(isValid()) {
            
            email = email.replacingOccurrences(of: ".", with: DOT)
            
            let usersDB = Database.database().reference().child("\(USERDB)")
            
            usersDB.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(self.email) {
                    MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "The email already exists")
                } else {
                    self.continueWithPhoneNumber()
                }
            })
            
        }
    }
    
    func continueWithPhoneNumber() {
        
        let phoneNumbersDB = Database.database().reference().child("\(PHONENUMBERDB)")
        
        phoneNumbersDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(self.phoneNumber) {
                MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "The phone number already exists")
            } else {
                self.registerUser()
            }
        })
        
    }
    
    func registerUser() {
        //usersDB.child(email).setValue(["email" : email])
        let usersDB = Database.database().reference().child("\(USERDB)/\(email)")
        let phoneNumbersDB = Database.database().reference().child("\(PHONENUMBERDB)/\(phoneNumber)")
        
        let uuid = UUID().uuidString
        usersDB.child(PREF_PASSWORD).setValue(password)
        usersDB.child(PREF_UUID).setValue(uuid)
        phoneNumbersDB.child(PREF_PASSWORD).setValue(password)
        phoneNumbersDB.child(PREF_UUID).setValue(uuid)
        
        UserDefaultStandard.share.saveString(value: "true", key: PREF_LOGIN)
        UserDefaultStandard.share.saveString(value: email, key: PREF_EMAIL)
        UserDefaultStandard.share.saveString(value: password, key: PREF_PASSWORD)
        UserDefaultStandard.share.saveString(value: uuid, key: PREF_UUID)
        
        self.performSegue(withIdentifier: "signuptohome", sender: nil)
    }
    
    func isValid() -> Bool {
        
        email = emailTf.text ?? ""
        phoneNumber = phoneNumberTf.getFormattedPhoneNumber() ?? ""
        password = passwordTf.text ?? ""
        confirm = confirmTf.text ?? ""
    
        
        if email.isEmpty {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "User email is required")
            return false
        }
        
        if !email.isValidEmail() {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Invalid email")
            return false
        }
        
        if phoneNumber.isEmpty {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Invalid phone number")
            return false
        }
        
        if password.isEmpty {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Password is required")
            return false
        }
        
        if password.count < 6 {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Password should be at least 6 characters")
            return false
        }
        
        if password != confirm {
           MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "The password does not match")
            return false
        }
        
        return true
    }
    

    
    func initButton() {
        signUpBtn.layer.cornerRadius = 10
        signUpBtn.layer.masksToBounds = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTf:
            phoneNumberTf.becomeFirstResponder()
        case phoneNumberTf:
            passwordTf.becomeFirstResponder()
        case passwordTf:
            confirmTf.becomeFirstResponder()
        case confirmTf:
            confirmTf.resignFirstResponder()
        default:
            print("textFieldShouldReturn Error!")
        }
        
        return false
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
