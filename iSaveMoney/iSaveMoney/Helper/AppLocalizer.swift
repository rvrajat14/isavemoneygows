//
//  AppLocalizer.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/3/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//
import Foundation
import UIKit

class AppLocalizer: NSObject {
    class func DoTheSwizzling() {
        // 1
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: Selector(("specialLocalizedStringForKey:value:table:")))
    }
}
extension Bundle {
    
    func specialLocalizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
        /*2*/let currentLanguage = AppLanguage.currentAppleLanguage()
        var bundle = Bundle();
        /*3*/if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            bundle = Bundle(path: _path)!
        } else {
            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            bundle = Bundle(path: _path)!
        }
        /*4*/return (bundle.specialLocalizedStringForKey(key: key, value: value, table: tableName))
    }
}
/// Exchange the implementation of two methods for the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}
