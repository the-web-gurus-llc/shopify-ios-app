//
//  DefaultViewController.swift
//  ShopifyApplication
//
//  Created by puma on 08/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit
import iOSDropDown

class DefaultViewController: ViewController {

    @IBOutlet weak var metalDD: DropDown!
    @IBOutlet weak var metalFinishDD: DropDown!
    @IBOutlet weak var mainStoneShapeDD: DropDown!
    @IBOutlet weak var sideStoneShapeDD: DropDown!
    
    @IBOutlet weak var mainStoneTypeTf: UITextField!
    @IBOutlet weak var mainStoneColorTf: UITextField!
    @IBOutlet weak var centerStoneSizeTf: UITextField!
    @IBOutlet weak var weightOfCenterStoneTf: UITextField!
    @IBOutlet weak var mainStoneClarifyTf: UITextField!
    @IBOutlet weak var numberOfSideStoneTf: UITextField!
    @IBOutlet weak var sideStoneWeightTf: UITextField!
    @IBOutlet weak var sideStoneColorTf: UITextField!
    @IBOutlet weak var sideStoneClarifyTf: UITextField!
    @IBOutlet weak var totalCaratsForPieceTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDDList()
    }
    
    func initDDList() {
        initDD(dd: metalDD, fileName: "metal")
        initDD(dd: metalFinishDD, fileName: "metalfinish")
        initDD(dd: mainStoneShapeDD, fileName: "mainstoneshape")
        initDD(dd: sideStoneShapeDD, fileName: "sidestoneshape")
    }
    
    func initDD(dd: DropDown, fileName: String) {
        dd.optionArray = getStringArrayFromFile(fileName: fileName)
        if dd.optionArray.count != 0 {
            dd.text = dd.optionArray[0]
        }
        dd.layer.cornerRadius = 5
        dd.layer.borderColor = UIColor.gray.cgColor
        dd.layer.borderWidth = 1
        dd.layer.masksToBounds = true
    }
    
    override func selfSize() -> CGFloat {
        return 420
    }
    
    override func getDescription(ref: String) -> String {
        var bodyHtml = ""
        
        bodyHtml += VALUE_ENTER
        bodyHtml += ref + VALUE_ENTER
        bodyHtml += VALUE_ENTER
        
        bodyHtml += "METAL SPECIFICATIONS\(VALUE_ENTER)"
        bodyHtml += metalDD.text! + VALUE_ENTER
        bodyHtml += VALUE_ENTER
        
        bodyHtml += "STONE SPECIFICATIONS\(VALUE_ENTER)"
        bodyHtml += "Stone Name : " + "Natural " + mainStoneTypeTf.text! + VALUE_ENTER
        bodyHtml += "Stone Shape :" + mainStoneShapeDD.text! + VALUE_ENTER
        bodyHtml += "Stone Details : " + "There are 2 \(mainStoneShapeDD.text!) \(mainStoneTypeTf.text!) approx. \(weightOfCenterStoneTf.text!) carats average size. Natural earth mined stones."
        bodyHtml += VALUE_ENTER
        bodyHtml += "Color of Main Stone : \(mainStoneColorTf.text!)" + VALUE_ENTER
        bodyHtml += "Clarity of Main Stone : \(mainStoneClarifyTf.text!)" + VALUE_ENTER
        bodyHtml += "Total : Approx. \(totalCaratsForPieceTf.text!) Carats" + VALUE_ENTER
        
        return bodyHtml
    }
    
    override func getTitle(jewelryType: String) -> String {
        
        var title = ""
        
        if !totalCaratsForPieceTf.text!.isEmpty {
            title = totalCaratsForPieceTf.text! + " Carats "
        }
        
        title = title + jewelryType
        title = title + mainStoneShapeDD.text!
        title = title + getRealString(str: mainStoneTypeTf.text!)
        title = title + getRealString(str: mainStoneColorTf.text!)
        title = title + getRealString(str: mainStoneClarifyTf.text!)
        title = title + metalDD.text!
        
        return title
    }
    
    override func getRealString(str: String) -> String {
        return super.getRealString(str: str)
    }

}
