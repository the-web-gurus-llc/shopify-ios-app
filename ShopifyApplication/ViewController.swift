//
//  ViewController.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func selfSize() -> CGFloat {
        return 100
    }
    
    func getTitle(jewelryType: String) -> String {
        return ""
    }
    
    func getDescription(ref: String) -> String {
        return ""
    }
    
    func getRealString(str: String) -> String {
        if str.isEmpty {
            return ""
        }
        return " \(str)"
    }

}

