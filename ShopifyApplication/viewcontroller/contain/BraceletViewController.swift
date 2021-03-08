//
//  BraceletViewController.swift
//  ShopifyApplication
//
//  Created by puma on 08/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit
import iOSDropDown

class BraceletViewController: ViewController {
    
    @IBOutlet weak var braceletTypeDD: DropDown!
    @IBOutlet weak var braceletGenderDD: DropDown!
    @IBOutlet weak var lengthInInchesDD: DropDown!
    @IBOutlet weak var braceletResizableDD: DropDown!
    @IBOutlet weak var mainStoneDD: DropDown!
    @IBOutlet weak var mainStoneCreationDD: DropDown!
    @IBOutlet weak var mainStoneCutDD: DropDown!
    @IBOutlet weak var mainStoneCutQualityDD: DropDown!
    @IBOutlet weak var mainStoneColorDD: DropDown!
    @IBOutlet weak var mainStoneClarityDD: DropDown!
    @IBOutlet weak var appraisalIncludedDD: DropDown!
    @IBOutlet weak var labDD: DropDown!
    @IBOutlet weak var sideStonesDD: DropDown!
    @IBOutlet weak var sideStoneCreationDD: DropDown!
    @IBOutlet weak var sideStoneCutDD: DropDown!
    @IBOutlet weak var sideStoneColorDD: DropDown!
    @IBOutlet weak var sideStoneClarityDD: DropDown!
    @IBOutlet weak var metalDD: DropDown!
    @IBOutlet weak var metalStampDD: DropDown!
    @IBOutlet weak var centerPearlSizeDD: DropDown!
    @IBOutlet weak var jewelryUniformityDD: DropDown!
    @IBOutlet weak var jewelryPearlLusterDD: DropDown!
    @IBOutlet weak var jewelryPearlNacreDD: DropDown!
    @IBOutlet weak var jewelryPearlShapeDD: DropDown!
    @IBOutlet weak var jewelryPearlSurfaceDD: DropDown!
    @IBOutlet weak var jewelryPearlBodyColorDD: DropDown!
    @IBOutlet weak var jewelryPearlOvertoneDD: DropDown!
    
    @IBOutlet weak var widthTf: UITextField!
    @IBOutlet weak var mainStoneCaratsTf: UITextField!
    @IBOutlet weak var mainStoneSizeTf: UITextField!
    @IBOutlet weak var numberofMainStonesTf: UITextField!
    @IBOutlet weak var sideStoneCaratsTf: UITextField!
    @IBOutlet weak var totalCaratsTf: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initDDList()
    }
    
    func initDDList() {
        initDD(dd: braceletTypeDD, fileName: "braceletTypeSpin")
        initDD(dd: braceletGenderDD, fileName: "braceletGenderSpin")
        initDD(dd: lengthInInchesDD, fileName: "lengthInInchesSpin")
        initDD(dd: braceletResizableDD, fileName: "braceletResizableSpin")
        initDD(dd: mainStoneDD, fileName: "mainStoneSpin")
        initDD(dd: mainStoneCutDD, fileName: "mainStoneCutSpin")
        initDD(dd: mainStoneCreationDD, fileName: "mainStoneCreationSpin")
        initDD(dd: mainStoneCutQualityDD, fileName: "mainStoneCutQualitySpin")
        initDD(dd: mainStoneColorDD, fileName: "mainStoneColorSpin")
        initDD(dd: mainStoneClarityDD, fileName: "mainStoneClaritySpin")
        initDD(dd: appraisalIncludedDD, fileName: "appraisalIncludeSpin")
        initDD(dd: labDD, fileName: "labSpin")
        initDD(dd: sideStonesDD, fileName: "sideStonesSpin")
        initDD(dd: sideStoneCreationDD, fileName: "sideStoneCreationSpin")
        initDD(dd: sideStoneCutDD, fileName: "sideStoneCutSpin")
        initDD(dd: sideStoneColorDD, fileName: "sideStoneColorSpin")
        initDD(dd: sideStoneClarityDD, fileName: "sideStoneClaritySpin")
        initDD(dd: metalDD, fileName: "metalSpin")
        initDD(dd: metalStampDD, fileName: "metalStampSpin")
        initDD(dd: centerPearlSizeDD, fileName: "centerPearlSizeSpin")
        initDD(dd: jewelryUniformityDD, fileName: "jewelryUniformitySpin")
        initDD(dd: jewelryPearlLusterDD, fileName: "jewelryPearlLusterSpin")
        initDD(dd: jewelryPearlNacreDD, fileName: "jewelryPearlNacreThicknessSpin")
        initDD(dd: jewelryPearlShapeDD, fileName: "jewelryPearlShapeSpin")
        initDD(dd: jewelryPearlSurfaceDD, fileName: "jewelryPearlSurfaceMarkingsSpin")
        initDD(dd: jewelryPearlBodyColorDD, fileName: "jewelryPearlBodyColorSpin")
        initDD(dd: jewelryPearlOvertoneDD, fileName: "jewelryPearlOvertoneSpin")
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
        return 1155
    }
    
    override func getTitle(jewelryType: String) -> String {
        
        var title = ""
        
        if !totalCaratsTf.text!.isEmpty {
            title = totalCaratsTf.text! + " Carats "
        }
        
        title = title + braceletTypeDD.text!
        title = title + mainStoneDD.text!
        title = title + mainStoneColorDD.text!
        title = title + mainStoneClarityDD.text!
        title = title + metalDD.text!
        
        return title
    }
    
    override func getDescription(ref: String) -> String {
        var bodyHtml = ""
        
        bodyHtml += VALUE_ENTER
        bodyHtml += ref + VALUE_ENTER
        bodyHtml += VALUE_ENTER
        
        bodyHtml = bodyHtml + "Bracelet Type :" + braceletTypeDD.text! + VALUE_ENTER +
            "Bracelet Gender :" + braceletGenderDD.text! + VALUE_ENTER +
            "Length in Inches :" + lengthInInchesDD.text! + VALUE_ENTER +
            "Width : " + widthTf.text! + VALUE_ENTER +
            "Bracelet Resizable  :" + braceletResizableDD.text! + VALUE_ENTER +
            "Main Stone/s :" + mainStoneDD.text! + VALUE_ENTER +
            "Main Stone Creation/Treatment :" + mainStoneCreationDD.text! + VALUE_ENTER +
            "Main Stone Cut :" + mainStoneCutDD.text! + VALUE_ENTER +
            "MainStoneCutQuality :" + mainStoneCutQualityDD.text! + VALUE_ENTER +
            "Main Stone Carats :" + mainStoneColorDD.text! + VALUE_ENTER +
            "Main Stone Size in mm : " + mainStoneSizeTf.text! + VALUE_ENTER +
            "Number of Main Stones : " + numberofMainStonesTf.text! + VALUE_ENTER +
            "Main Stone Color :" + mainStoneColorDD.text! + VALUE_ENTER +
            "Main Stone Clarity/Quality :" + mainStoneClarityDD.text! + VALUE_ENTER +
            "Appraisal Included :" + appraisalIncludedDD.text! + VALUE_ENTER +
            "Lab :" + labDD.text! + VALUE_ENTER +
            "Side Stones :" + sideStonesDD.text! + VALUE_ENTER +
            "Side Stone Creation/Treatment :" + sideStoneCreationDD.text! + VALUE_ENTER +
            "Side Stone Cut :" + sideStoneCutDD.text! + VALUE_ENTER +
            "Side Stone Carats :" + sideStoneCaratsTf.text! + VALUE_ENTER +
            "Side Stone Color :" + sideStoneColorDD.text! + VALUE_ENTER +
            "Side Stone Clarity/Quality :" + sideStoneClarityDD.text! + VALUE_ENTER +
            "Total Carats  : " + totalCaratsTf.text! + VALUE_ENTER +
            "Metal :" + metalDD.text! + VALUE_ENTER +
            "Metal Stamp :" + metalStampDD.text! + VALUE_ENTER +
            "Center PearlSize :" + centerPearlSizeDD.text! + VALUE_ENTER +
            "JewelryUniformity :" + jewelryUniformityDD.text! + VALUE_ENTER +
            "JewelryPearlLuster :" + jewelryPearlLusterDD.text! + VALUE_ENTER +
            "JewelryPearlNacreThickness :" + jewelryPearlNacreDD.text! + VALUE_ENTER +
            "JewelryPearlShape :" + jewelryPearlShapeDD.text! + VALUE_ENTER +
            "JewelryPearlSurfaceMarkings :" + jewelryPearlSurfaceDD.text! + VALUE_ENTER +
            "JewelryPearlBodycolor :" + jewelryPearlBodyColorDD.text! + VALUE_ENTER +
            "JewelryPearlOvertone :" + jewelryPearlOvertoneDD.text! + VALUE_ENTER
        
        return bodyHtml
    }

}
