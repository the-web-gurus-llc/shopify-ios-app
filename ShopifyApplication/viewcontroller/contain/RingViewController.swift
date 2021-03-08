//
//  RingViewController.swift
//  ShopifyApplication
//
//  Created by puma on 08/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit
import iOSDropDown

class RingViewController: ViewController {
    
    @IBOutlet weak var ringStyleDD: DropDown!
    @IBOutlet weak var subRingStyleDD: DropDown!
    @IBOutlet weak var ringGenderDD: DropDown!
    @IBOutlet weak var ringSizeDD: DropDown!
    @IBOutlet weak var ringResizableDD: DropDown!
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
    @IBOutlet weak var jewelryPearlNacreThickness: DropDown!
    @IBOutlet weak var jewelryPearlShapeDD: DropDown!
    @IBOutlet weak var jewelryPearlSurfaceDD: DropDown!
    @IBOutlet weak var jewelryPearlBodyDD: DropDown!
    @IBOutlet weak var jewelryPearlOverDD: DropDown!
    
    @IBOutlet weak var faceOverallDimensionsDD: UITextField!
    @IBOutlet weak var mainStoneCaratsDD: UITextField!
    @IBOutlet weak var mainStoneMMDD: UITextField!
    @IBOutlet weak var certNumberDD: UITextField!
    @IBOutlet weak var sideStoneCaratsDD: UITextField!
    @IBOutlet weak var totalCaratsDD: UITextField!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subRingStyleViewHeight: NSLayoutConstraint!
    let SUBRINGSTYLEVIEWHEIGHT: CGFloat = 30
    let TOPVIEWHEIGHT: CGFloat = 345
    
    @IBOutlet weak var subRingStyleLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDDList()
    }
    
    func initDDList() {
        initDD(dd: ringStyleDD, fileName: "ringStyleDD")
        initDD(dd: ringGenderDD, fileName: "ringGenderDD")
        initDD(dd: ringSizeDD, fileName: "ringSizeDD")
        initDD(dd: ringResizableDD, fileName: "ringResizableDD")
        initDD(dd: mainStoneDD, fileName: "mainStoneDD")
        initDD(dd: mainStoneCutDD, fileName: "mainStoneCutDD")
        initDD(dd: mainStoneCreationDD, fileName: "mainStoneCreationDD")
        initDD(dd: mainStoneCutQualityDD, fileName: "mainStoneCutQualityDD")
        initDD(dd: mainStoneColorDD, fileName: "mainStoneColorDD")
        initDD(dd: mainStoneClarityDD, fileName: "mainStoneClarityDD")
        initDD(dd: appraisalIncludedDD, fileName: "appraisalIncludedDD")
        initDD(dd: labDD, fileName: "labDD")
        initDD(dd: sideStonesDD, fileName: "sideStonesDD")
        initDD(dd: sideStoneCreationDD, fileName: "sideStoneCreationDD")
        initDD(dd: sideStoneCutDD, fileName: "sideStoneCutDD")
        initDD(dd: sideStoneColorDD, fileName: "sideStoneColorDD")
        initDD(dd: sideStoneClarityDD, fileName: "sideStoneClarityDD")
        initDD(dd: metalDD, fileName: "metalDD")
        initDD(dd: metalStampDD, fileName: "metalStampDD")
        initDD(dd: centerPearlSizeDD, fileName: "centerPearlSizeDD")
        initDD(dd: jewelryUniformityDD, fileName: "jewelryUniformityDD")
        initDD(dd: jewelryPearlLusterDD, fileName: "jewelryPearlLusterDD")
        initDD(dd: jewelryPearlNacreThickness, fileName: "jewelryPearlNacreThickness")
        initDD(dd: jewelryPearlShapeDD, fileName: "jewelryPearlShapeDD")
        initDD(dd: jewelryPearlSurfaceDD, fileName: "jewelryPearlSurfaceDD")
        initDD(dd: jewelryPearlBodyDD, fileName: "jewelryPearlBodyDD")
        initDD(dd: jewelryPearlOverDD, fileName: "jewelryPearlOverDD")
        
        ringStyleDD.didSelect{(selectedText , index ,id) in
            self.didSelectRingStyle(index: index)
        }
        
        changeSubRingStyle(isHide: true, name: "Baby")
        
    }
    
    func didSelectRingStyle(index: Int) {
        switch index {
        case 0:
            changeSubRingStyle(isHide: true, name: "Baby")
        case 1:
            changeSubRingStyle(isHide: false, name: "Color Stone")
        case 2:
            changeSubRingStyle(isHide: false, name: "Engagement")
        case 3:
            changeSubRingStyle(isHide: false, name: "Engagement Set")
        case 4:
            changeSubRingStyle(isHide: true, name: "Eternity Band")
        case 5:
            changeSubRingStyle(isHide: false, name: "Fancy")
        case 6:
            changeSubRingStyle(isHide: false, name: "Men's Ring")
        case 7:
            changeSubRingStyle(isHide: true, name: "Semi-Mount")
        case 8:
            changeSubRingStyle(isHide: true, name: "Toe Rings")
        case 9:
            changeSubRingStyle(isHide: true, name: "Band")
        case 10:
            changeSubRingStyle(isHide: false, name: "Wedding Band Set")
        default:
            print("subRingStyle Change Error")
        }
    }
    
    func changeSubRingStyle(isHide: Bool, name: String) {
        
        subRingStyleDD.isHidden = isHide
        subRingStyleLb.isHidden = isHide
        
        if isHide {
            subRingStyleViewHeight.constant = 0
            topViewHeight.constant = TOPVIEWHEIGHT - SUBRINGSTYLEVIEWHEIGHT
            return
        }
        
        topViewHeight.constant = TOPVIEWHEIGHT
        subRingStyleViewHeight.constant = SUBRINGSTYLEVIEWHEIGHT
        subRingStyleLb.text = "\(name) :"
        var fileName = name.replacingOccurrences(of: " ", with: "")
        fileName = fileName.replacingOccurrences(of: "'", with: "")
        fileName = fileName.lowercased()
        fileName = fileName + "_subring"
        
        subRingStyleDD.optionArray.removeAll()
        initDD(dd: subRingStyleDD, fileName: fileName)
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
        return 1190
    }
    
    override func getRealString(str: String) -> String {
        return super.getRealString(str: str)
    }
    
    override func getTitle(jewelryType: String) -> String {
        
        var title = ""
        
        if !totalCaratsDD.text!.isEmpty {
            title = totalCaratsDD.text! + " Carats "
        }
        
        title = title + jewelryType
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
        
        bodyHtml += "Ring Style :" + ringStyleDD.text! + VALUE_ENTER
        if(subRingStyleDD.isHidden == false) {
            bodyHtml += "\(subRingStyleLb.text!) : " + subRingStyleDD.text! + VALUE_ENTER
        }
        
        bodyHtml = bodyHtml + "Face Overall Dimensions (In mm) : " + faceOverallDimensionsDD.text! + VALUE_ENTER +
            "RingGender :" + ringGenderDD.text! + VALUE_ENTER +
            "Ring Size  :" + ringSizeDD.text! + VALUE_ENTER +
            "Ring Resizable :" + ringResizableDD.text! + VALUE_ENTER +
            "Main Stone/s :" + mainStoneDD.text! + VALUE_ENTER +
            "Main Stone Creation/Treatment :" + mainStoneCreationDD.text! + VALUE_ENTER +
            "Main Stone Cut :" + mainStoneCutDD.text! + VALUE_ENTER +
            "MainStoneCutQuality :" + mainStoneCutQualityDD.text! + VALUE_ENTER +
            "Main Stone Carats : " + mainStoneCaratsDD.text! + VALUE_ENTER +
            "Main Stone mm : " + mainStoneMMDD.text! + VALUE_ENTER +
            "Main Stone Color :" + mainStoneColorDD.text! + VALUE_ENTER +
            "Main Stone Clarity/Quality :" + mainStoneClarityDD.text! + VALUE_ENTER +
            "Appraisal Included :" + appraisalIncludedDD.text! + VALUE_ENTER +
            "Lab :" + labDD.text! + VALUE_ENTER +
            "Cert Number : " + certNumberDD.text! + VALUE_ENTER +
            "Side Stones :" + sideStonesDD.text! + VALUE_ENTER +
            "Side Stone Creation/Treatment: " + sideStoneCreationDD.text! + VALUE_ENTER +
            "Side Stone Cut :" + sideStoneCutDD.text! + VALUE_ENTER +
            "Side Stone Carats : " + sideStoneCaratsDD.text! + VALUE_ENTER +
            "Side Stone Color :" + sideStoneColorDD.text! + VALUE_ENTER +
            "Side Stone Clarity/Quality :" + sideStoneClarityDD.text! + VALUE_ENTER +
            "Total Carats  : " + totalCaratsDD.text! + VALUE_ENTER +
            "Metal :" + metalDD.text! + VALUE_ENTER +
            "Metal Stamp :" + metalStampDD.text! + VALUE_ENTER +
            "Center PearlSize :" + centerPearlSizeDD.text! + VALUE_ENTER +
            "JewelryUniformity :" + jewelryUniformityDD.text! + VALUE_ENTER +
            "JewelryPearlLuster :" + jewelryPearlLusterDD.text! + VALUE_ENTER +
            "JewelryPearlNacreThickness :" + jewelryPearlNacreThickness.text! + VALUE_ENTER +
            "JewelryPearlShape :" + jewelryPearlShapeDD.text! + VALUE_ENTER +
            "JewelryPearlSurfaceMarkings :" + jewelryPearlSurfaceDD.text! + VALUE_ENTER +
            "JewelryPearlBodycolor :" + jewelryPearlBodyDD.text! + VALUE_ENTER +
            "JewelryPearlOvertone :" + jewelryPearlOverDD.text! + VALUE_ENTER
        
        return bodyHtml
    }
    
}
