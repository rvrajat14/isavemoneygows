//
//  TBUtils.swift
//  ToolsBoxModule
//
//  Created by ARMEL KOUDOUM on 12/10/20.
//

import Foundation
import UIKit

public class TBUtils {
    public static func getCalculator() -> CalculatorViewController {
        return CalculatorViewController(nibName: "CalculatorViewController", bundle: Bundle(identifier: CalConsts.BUNDLE_ID))
    }
}
