//
//  RegisterFonts.swift
//  HelpCenter
//
//  Created by Armel Koudoum on 7/11/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit


extension UIFont {

    public class func loadAllFonts() {
        registerFontWithFilenameString(withFilenameString: "Roboto-Bold", bundle: Bundle(for: self))
        registerFontWithFilenameString(withFilenameString: "Roboto-Medium", bundle: Bundle(for: self))
        registerFontWithFilenameString(withFilenameString: "Roboto-Regular", bundle: Bundle(for: self))
        registerFontWithFilenameString(withFilenameString: "Roboto-Light", bundle: Bundle(for: self))
    }

    static func registerFontWithFilenameString(withFilenameString filenameString: String, bundle: Bundle) {

        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: "ttf") else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }

        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}

class RegisterFonts {
    
}
