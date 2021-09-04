//
//  Constants.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

public class IsmConstants {
    let HelpCenterBundleName = "com.digitleaf.helpcenter"
    let AccountsBundleName = "com.digitleaf.AccountsModule"
}


public class Environment {
    //static let ENVIRONEMENT:String = ""
    #if ENV_DEV
    public static let ENVIRONEMENT:String = ""
    #elseif ENV_MM
    public static let ENVIRONEMENT:String = ""
    #elseif ENV_PROD
    public static let ENVIRONEMENT:String = ""
    #else
    public static let ENVIRONEMENT:String = ""
    #endif
}
