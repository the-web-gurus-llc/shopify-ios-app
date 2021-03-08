//
//  MyImage.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import Foundation

class MyImage: NSObject {
    var id: Int64
    var product_id: Int64
    var src: String
    
    override init() {
        id = 0
        product_id = 0
        src = ""
    }
}
