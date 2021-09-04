//
//  GlobalPreferences.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/11/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import Foundation

public class GlobalPreferences {
    
    let PREF_SHOW_ONBOARDING = "pref_show_onboarding"
    var defaults:UserDefaults
    
    public init() {
        defaults = UserDefaults.standard
    }
    
    public func setShowOnboarding(_ state: Bool) -> Void {
        
        defaults.set(state, forKey: self.PREF_SHOW_ONBOARDING)
        
    }
    
    public func hasShowOnboarding() -> Bool {
        
        return defaults.bool(forKey: self.PREF_SHOW_ONBOARDING) ?? true
    }
}
