//
//  AppLanguage.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/3/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// L102Language
class AppLanguage {
    /// get current Apple language
    class func currentAppleLanguage() -> String {
        
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}
