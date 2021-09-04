//
//  Flavor.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/7/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public enum FlavorType {
    
    case legacy
    case moneymaximixer
}

public class legacyChrome {
    
    public static let DARK_BLUE:UIColor = UIColor(red:0.10, green:0.46, blue:0.82, alpha:1.0)
    public static let BLUE:UIColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
    public static let PINK:UIColor = UIColor(red:1.00, green:0.25, blue:0.50, alpha:1.0)
    public static let LIGHT_BLUE:UIColor = UIColor(red:0.26, green:0.65, blue:0.96, alpha:1.0)
    public static let WHITE:UIColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    public static let LIGHT_GREY:UIColor = UIColor(red:0.56, green:0.58, blue:0.61, alpha:1.0)
    public static let GREY_CLEAR:UIColor = UIColor(red:0.56, green:0.58, blue:0.61, alpha:0.3)
    public static let DARK:UIColor = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
   
}

public class mmChrome {
    
    public static let DARK_BLUE:UIColor = UIColor(red:0.10, green:0.46, blue:0.82, alpha:1.0)
    public static let BLUE:UIColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
    public static let PINK:UIColor = UIColor(red:1.00, green:0.25, blue:0.50, alpha:1.0)
    public static let LIGHT_BLUE:UIColor = UIColor(red:0.26, green:0.65, blue:0.96, alpha:1.0)
    public static let WHITE:UIColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    public static let LIGHT_GREY:UIColor = UIColor(red:0.56, green:0.58, blue:0.61, alpha:1.0)
    //yellow #dbaa40
    public static let YELLOW:UIColor = UIColor(red:0.86, green:0.67, blue:0.25, alpha:1.0)
    public static let GREEN:UIColor = UIColor(red:0.86, green:0.67, blue:0.25, alpha:1.0)
    //Dark #29282a
    public static let DARK:UIColor = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
    //gradiant #B97701
    public static let GRADIANT_1:UIColor = UIColor(red:0.73, green:0.47, blue:0.00, alpha:1.0)
    //gradiant #F4CF6E
    public static let GRADIANT_2:UIColor = UIColor(red:0.96, green:0.81, blue:0.43, alpha:1.0)
}


public class Flavor {
    
    public var flavor: FlavorType
    


    public var primaryColor:UIColor!
    public var primaryDarkColor:UIColor!
    public var accentColor:UIColor!
    public var navigationThint:UIColor!
    public var tabBarItem:UIColor!
    public var navigationBarColor:UIColor!
    
    public init() {
        flavor = FlavorType.legacy
        
        #if ENV_DEV
        flavor = FlavorType.legacy
        #elseif ENV_MM
        flavor = FlavorType.moneymaximixer
        #elseif ENV_PROD
        flavor = FlavorType.legacy
        #endif
        
        if flavor == FlavorType.legacy {
            primaryColor = legacyChrome.BLUE
            primaryDarkColor = legacyChrome.DARK_BLUE
            accentColor = mmChrome.YELLOW
            navigationThint = legacyChrome.WHITE
            tabBarItem = mmChrome.LIGHT_GREY
            navigationBarColor = mmChrome.WHITE
        } else {
            primaryColor = mmChrome.DARK
            primaryDarkColor = mmChrome.DARK
            accentColor = mmChrome.YELLOW
            navigationThint = mmChrome.LIGHT_GREY
            tabBarItem = mmChrome.LIGHT_GREY
            navigationBarColor = mmChrome.WHITE
        }
    }
    
    public func getNavigationBarColor() -> UIColor {
        return navigationBarColor
    }
    public func getFlavor() -> FlavorType {
        return flavor
    }
    
    public func getPrimaryColor() -> UIColor {
        return primaryColor
    }
    
    public func getPrimaryDarkColor() -> UIColor {
        return primaryDarkColor
    }
    
    public func getAccentColor() -> UIColor {
        return accentColor
    }
    
    public func getNavigationThintColor() -> UIColor {
        return navigationThint
    }
    public func getTabBarItemThintColor() -> UIColor {
        return tabBarItem
    }
}
