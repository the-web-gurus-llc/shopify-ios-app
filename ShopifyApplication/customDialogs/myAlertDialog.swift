//
//  myAlertDialog.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import Foundation
import UIKit

class MyAlertDialog {
    
    static let share = MyAlertDialog()
    static let WARNING = "Warning"
    
    private init() {}
    func showAlert(vc: UIViewController, title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        
    }
}
