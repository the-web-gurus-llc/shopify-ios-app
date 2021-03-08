//
//  SignInViewController.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signInwithTouchBtn: UIButton!
    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    var email = ""
    var password = ""
    var uuid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preSetup()
    }
    
    @IBAction func onClickSignInWithTouchID(_ sender: Any) {
        let currentUser = UserDefaultStandard.share.getString(key: PREF_EMAIL)
        if currentUser.isEmpty {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Please sign in or sign up to enable this function.")
            return
        }
        
        authenticateUser()
        
    }
    
    func authenticateUser() {
        let context = LAContext()
        context.localizedFallbackTitle = ""
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.loginWithTouch()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func onClickSignIn(_ sender: Any) {
        if isValid() {
            email = email.replacingOccurrences(of: ".", with: DOT)
            
            var dbRef : DatabaseReference
            if email.contains("@") {
                dbRef = Database.database().reference().child("\(USERDB)/\(email)")
            } else {
                dbRef = Database.database().reference().child("\(PHONENUMBERDB)/\(email)")
            }
            
            dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    if let user = snapshot.value as? [String:String] {
                        if self.password == user[PREF_PASSWORD] {
                            self.uuid = user[PREF_UUID] ?? ""
                            self.logIn()
                        } else {
                             MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Incorrect password")
                        }
                    } else {
                        MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Can't log in")
                    }
                    
                } else {
                    MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "User not found")
                }
            })
        }
    }
    
    func loginWithTouch() {
        UserDefaultStandard.share.saveString(value: "true", key: PREF_LOGIN)
        self.performSegue(withIdentifier: "signintohome", sender: nil)
    }
    
    func logIn() {
        
        if uuid.isEmpty {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Server Error!")
            return
        }
        
        UserDefaultStandard.share.saveString(value: "true", key: PREF_LOGIN)
        UserDefaultStandard.share.saveString(value: email, key: PREF_EMAIL)
        UserDefaultStandard.share.saveString(value: password, key: PREF_PASSWORD)
        UserDefaultStandard.share.saveString(value: uuid, key: PREF_UUID)
        
        self.performSegue(withIdentifier: "signintohome", sender: nil)
    }
    
    func preSetup() {
        if checkLogin() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "homevc") as! HomeViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nav
        }
        
        initButton()
        emailTf.delegate = self
        passwordTf.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func isValid() -> Bool {
        
        email = emailTf.text ?? ""
        password = passwordTf.text ?? ""
        
        if email.isEmpty {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Email or Phone Number required")
            return false
        }
        
        if !email.contains("@") {
            if !email.contains("+") {
                  MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Phone Number invalid. (ex: +14844732475)")
                return false
            }
        }
        
        if password.isEmpty {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Password is required")
            return false
        }
        
        if password.count < 6 {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Password should be at least 6 characters")
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTf:
            passwordTf.becomeFirstResponder()
        case passwordTf:
            passwordTf.resignFirstResponder()
        default:
            print("textFieldShouldReturn Error!")
        }
        
        return false
    }
    
    func checkLogin() -> Bool {
        if UserDefaultStandard.share.getString(key: PREF_LOGIN) == "true" {
            return true
        }
        return false
    }

    func initButton() {
        signInBtn.layer.cornerRadius = 10
        signInBtn.layer.masksToBounds = true
        signInwithTouchBtn.layer.cornerRadius = 10
        signInwithTouchBtn.layer.masksToBounds = true
    }

    
}
