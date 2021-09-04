//
//  AccessPref.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/17/20.
//

import Foundation

public class AccessPref{
    public static var IS_USER_PREMIUM = "is_user_pro"
    public static var PREF_USER_IDENTIFIER = "pref_user_identifier"
    public static var PREF_DATE_FORMAT = "date_format"
    var defaults:UserDefaults
    
    public init() {
        defaults = UserDefaults.standard
    }
    
    public func setStringVal(val: String, forKey: String) -> Void {
        defaults.set(val, forKey: forKey)
    }
    
    public func getStringVal(forKey: String, defVal:String) -> String {
        return defaults.string(forKey: forKey) ?? defVal
    }
    
    public func setBoolVal(val: Bool, forKey: String) -> Void {
        defaults.set(val, forKey: forKey)
    }
    
    public func getBoolVal(forKey: String, defVal:Bool) -> Bool {
        return defaults.bool(forKey: forKey)
    }
    
    public func isProAccount() -> Bool {
        if (Bundle.main.infoDictionary?["Target"] as? String ) == "develop" {
            return true
        }
        
        return getBoolVal(forKey: AccessPref.IS_USER_PREMIUM, defVal: false)
    }
}
