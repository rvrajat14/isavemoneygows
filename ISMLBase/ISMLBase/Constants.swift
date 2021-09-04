//
//  Constants.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/30/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit



public enum BudgetType : Int {
    case BLANK = 0
    case PERSONAL = 1
    case FAMILY = 2
    case HOUSEHOLD = 3

}


public class Const {
    //Cloud function url
    #if ENV_DEV
    public static let CLOUD_FUNCTION:String = "https://us-central1-isavemoneygo-developement.cloudfunctions.net/"
    #elseif ENV_MM
    public static let CLOUD_FUNCTION:String = "https://us-central1-moneymaximixer.cloudfunctions.net/"
    #elseif ENV_PROD
    public static let CLOUD_FUNCTION:String = "https://us-central1-isavemoney-1214.cloudfunctions.net/"
    #else
    public static let CLOUD_FUNCTION:String = "https://us-central1-isavemoney-1214.cloudfunctions.net/"
    #endif
    
    public static let RED:UIColor = UIColor(red:1.00, green:0.23, blue:0.18, alpha:1.0)
    public static let BLUE:UIColor = UIColor(red:0.20, green:0.67, blue:0.86, alpha:1.0)
    public static let GREEN:UIColor = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
    public static let GREY:UIColor = UIColor(red: 0.9412, green: 0.9412, blue: 0.9412, alpha: 1.0)
    public static let GREY_CLEAR:UIColor = UIColor(red: 0.9412, green: 0.9412, blue: 0.9412, alpha: 0.4)
    public static let INFO_GREEN:UIColor = UIColor(red:0.01, green:0.77, blue:0.74, alpha:1.0)
    public static let INFO_GREEN_BG:UIColor = UIColor(red:0.83, green:0.93, blue:0.85, alpha:1.0)
    
    public static let LICENCE_PREMIUM:String = "premium"
    public static let LICENCE_FREE:String = "free"
    public static let LICENCE_SUBSCRIBE:String = "subscribe"
    
    public static let ANONIMOUS:String = "anonymous"
    public static let SCREEN_LOCK_CODE:String = "SAFEMONEY2018"
    
    public static let PLATFORM_NAME = "ios"
    
    public static let ORDER_STATE_PURCHASED = "New purchase completed"
    public static let ORDER_STATE_RESTORED = "New purchase restored"
    
    public static func isPRO(licenseType:String) -> Bool {
        return (licenseType == Const.LICENCE_PREMIUM || licenseType == Const.LICENCE_SUBSCRIBE)
    }
    
    public static let NUMBER_FREE_BUDGET:Int = 2
    
     //blue
    public static let drawerColor:UIColor = UIColor(red:0.27, green:0.61, blue:1.00, alpha:1.0)
    public static let background1:UIColor = UIColor(red:0.30, green:0.63, blue:1.00, alpha:1.0)
    public static let background2:UIColor = UIColor(red:0.73, green:0.89, blue:1.00, alpha:1.0)
    public static let tabBarMenu:UIColor = UIColor(red:0.80, green:0.91, blue:1.00, alpha:1.0)
    
    public static let tabBarMenuTint:UIColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
    
    public static let graphicsColor:UIColor = UIColor(red:0.30, green:0.99, blue:0.56, alpha:1.0)
    public static let blueText:UIColor = UIColor(red:0.42, green:0.70, blue:1.00, alpha:1.0)
    public static let whiteText:UIColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    
    public static let grayTest:UIColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)

    public static let grayBackground:UIColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    public static let greyDarkColor:UIColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
    
    public static let COLORS_ARRAY=[UIColor(red: 0.13, green: 0.38, blue: 0.69, alpha: 1.00),UIColor(red: 0.35, green: 0.68, blue: 0.72, alpha: 1.00),UIColor(red: 0.96, green: 0.71, blue: 0.16, alpha: 1.00),UIColor(red: 0.87, green: 0.24, blue: 0.28, alpha: 1.00),UIColor(red: 0.75, green: 0.54, blue: 0.68, alpha: 1.00),UIColor(red: 0.36, green: 0.53, blue: 0.75, alpha: 1.00),UIColor(red: 0.35, green: 0.74, blue: 0.06, alpha: 1.00),UIColor(red: 0.91, green: 0.44, blue: 0.20, alpha: 1.00),UIColor(red: 0.97, green: 0.30, blue: 0.27, alpha: 1.00),UIColor(red: 0.55, green: 0.28, blue: 0.98, alpha: 1.00),UIColor(red: 0.32, green: 0.76, blue: 0.93, alpha: 1.00),UIColor(red: 0.55, green: 0.77, blue: 0.33, alpha: 1.00),UIColor(red: 0.76, green: 0.60, blue: 0.49, alpha: 1.00),UIColor(red: 0.81, green: 0.47, blue: 0.47, alpha: 1.00),UIColor(red: 0.56, green: 0.53, blue: 0.73, alpha: 1.00)]
    
    public static func getColorByCharacter(character:String)->UIColor{
        var charact = character
        if character == " " {
            charact = "Z"
        }
            
        if let unicodeValue = charact.uppercased().unicodeScalars.first{
            let unicodeNumber = Int(unicodeValue.value)
            return COLORS_ARRAY[(unicodeNumber - ((unicodeNumber-48<10) ? 48 : 65)) % COLORS_ARRAY.count]
        }
        return Const.graphicsColor
    }
}



public class ColorsSet {
    
    public var mColor:[UIColor]=[]
    
    public func getColors() -> [UIColor] {
        return self.mColor
    }
    public init() {
        //#ff5e3a
        mColor.append(UIColor(red:1.0, green:0.37, blue:0.23, alpha:1.0))
        //#ff2a68
        mColor.append(UIColor(red:1.0, green:0.16, blue:0.41, alpha:1.0))
        //#ff9500
        mColor.append(UIColor(red:1.0, green:0.58, blue:0.0, alpha:1.0))
        //#ff5e3a
        //mColor.append(UIColor(red:1.0, green:0.37, blue:0.23, alpha:1.0))
        //#ffdb4c
        mColor.append(UIColor(red:1.0, green:0.86, blue:0.3, alpha:1.0))
        //#ffcd02
        mColor.append(UIColor(red:1.0, green:0.8, blue:0.01, alpha:1.0))
        //#87fc70
        mColor.append(UIColor(red:0.53, green:0.99, blue:0.44, alpha:1.0))
        //#0bd318
        mColor.append(UIColor(red:0.04, green:0.83, blue:0.09, alpha:1.0))
        //#52edc7
        mColor.append(UIColor(red:0.32, green:0.93, blue:0.78, alpha:1.0))
        //#5ac8fb
        mColor.append(UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0))
        //#1ad6fd
        mColor.append(UIColor(red:0.1, green:0.84, blue:0.99, alpha:1.0))
        //#1d62f0
        mColor.append(UIColor(red:0.11, green:0.38, blue:0.94, alpha:1.0))
        //#c644fc
        mColor.append(UIColor(red:0.78, green:0.27, blue:0.99, alpha:1.0))
        //#5856d6
        mColor.append(UIColor(red:0.35, green:0.34, blue:0.84, alpha:1.0))
        //#ef4db6
        mColor.append(UIColor(red:0.94, green:0.3, blue:0.71, alpha:1.0))
        //#c643fc
        mColor.append(UIColor(red:0.78, green:0.26, blue:0.99, alpha:1.0))
        //#4a4a4a
        mColor.append(UIColor(white:0.29, alpha:1.0))
        //#2b2b2b
        mColor.append(UIColor(white:0.17, alpha:1.0))
        //#dbddde
        mColor.append(UIColor(red:0.86, green:0.87, blue:0.87, alpha:1.0))
        //#898c90
        mColor.append(UIColor(red:0.54, green:0.55, blue:0.56, alpha:1.0))
        //#ff3b30
        mColor.append(UIColor(red:1.0, green:0.23, blue:0.19, alpha:1.0))
        //#ff9500
        mColor.append(UIColor(red:1.0, green:0.58, blue:0.0, alpha:1.0))
        //#ffcc00
        mColor.append(UIColor(red:1.0, green:0.8, blue:0.0, alpha:1.0))
        //#4cd964
        mColor.append(UIColor(red:0.3, green:0.85, blue:0.39, alpha:1.0))
        //#34aadc
        mColor.append(UIColor())
        //#007aff
        mColor.append(UIColor())
        //#5856d6
        mColor.append(UIColor())
        //#ff2d55
        mColor.append(UIColor())
        //#8e8e93
        mColor.append(UIColor())
        //#c7c7cc
        mColor.append(UIColor())
        //#5ad427
        mColor.append(UIColor())
        //#a4e786
        mColor.append(UIColor())
        //#c86edf
        mColor.append(UIColor())
        //#e4b7f0
        mColor.append(UIColor())
        //#D1EEFC
        mColor.append(UIColor())
        //#E0F8D8
        mColor.append(UIColor())
        //#fb2b69
        mColor.append(UIColor())
        //#ff5b37
        mColor.append(UIColor())
        //#f7f7f7
        mColor.append(UIColor())
        //#d7d7d7
        mColor.append(UIColor())
        //#1d77ef
        mColor.append(UIColor())
        //#81f3fd
        mColor.append(UIColor())
        //#d6cec3
        mColor.append(UIColor())
        //#e4ddca
        mColor.append(UIColor())
        //#55efcb
        mColor.append(UIColor())
        //#5bcaff
        mColor.append(UIColor())
        //#FF4981
        mColor.append(UIColor())
        //#FFD3E0
        mColor.append(UIColor())
        //#F7F7F7
        mColor.append(UIColor())
        //#FF1300
        mColor.append(UIColor())
        //#1F1F21
        mColor.append(UIColor())
        //#BDBEC2
        mColor.append(UIColor())
        //#FF3A2D Red
        mColor.append(UIColor(red:0.3, green:0.85, blue:0.39, alpha:1.0))
        
        
    }
}
