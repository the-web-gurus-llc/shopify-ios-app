//
//  Helper.swift
//  ShopifyApplication
//
//  Created by puma on 08/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import Foundation

func getStringArrayFromFile(fileName: String) -> [String] {
    do {
        let path: String = Bundle.main.path(forResource: "\(fileName)", ofType: "txt") ?? ""
        let file = try String(contentsOfFile: path)
        var text: [String] = file.components(separatedBy: "\n")
        text.removeLast()
        for i in 0 ..< text.count {
            text[i] = " \(text[i])"
        }
        return text
    } catch let error {
        Swift.print("Fatal Error: \(error.localizedDescription)")
        return [String]()
    }
}
