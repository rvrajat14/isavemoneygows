//
//  CoUtilities.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//

import Foundation
import UIKit

public class CoUtilities{
    public static func getHOneColor() -> UIColor?{
        return UIColor(named: "checkoutH1Color", in: Bundle(identifier: CoConst.BUNDLE_ID), compatibleWith: UITraitCollection.current)
    }
    
    public static func getUIColor(named: String) -> UIColor?{
        return UIColor(named: named, in: Bundle(identifier: CoConst.BUNDLE_ID), compatibleWith: UITraitCollection.current)
    }
    
    public static func fetchString(forKey key: String) -> String {
        var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)

            if result == key {
                result = Bundle(identifier: CoConst.BUNDLE_ID)?.localizedString(forKey: key, value: nil, table: "checkoutString") ?? ""
            }

            return result
    }
}
