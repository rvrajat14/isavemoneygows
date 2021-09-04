//
//  Constants.swift
//  Help Center
//
//  Created by DevD on 24/04/20.
//  Copyright © 2020 Devendra. All rights reserved.
//

import Foundation
import UIKit


let navigationBackgroundColor = UIColor.init(red: 225/255, green: 229/255, blue: 232/255, alpha: 1)
let navigationTitleColor = UIColor.init(red: 24/255, green: 76/255, blue: 221/255, alpha: 1)
let sectionTitleColor = UIColor.init(red: 68/255, green: 138/255, blue: 255/255, alpha: 1)
let sectionTitleFont = UIFont(name:"Lato-Heavy", size: 14)!
let sectionItemTitleFont = UIFont(name:"Lato-Bold", size: 14)!
let detailSubTitleFont = UIFont(name:"Lato-Heavy", size: 16)!
let detailTextFont = UIFont(name:"Lato-Regular", size: 12)!
let errorTextFont = UIFont(name:"Lato-Regular", size: 20)!
let searchTextFont = UIFont(name:"Lato-Regular", size: 14)!

let helpCenter = "Help Center"
let searchEnterInfo = "Type something to search in the\nsearch box above"
let noSearchFoundInfo = "No search found, please try\nother search"

let HelpCenterBundle = "com.digitleaf.helpcenter"

public class ImageLoader {
    public static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: Bundle(for: self), with: nil)
    }
}
