//
//  Transaction.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/17/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation

public enum TransactionType {
    case INCOMING
    case OUTGOING
    case HEADER
}

public enum TypeEntry {
    case INCOME
    case EXPENSE
    case TRANSFER_IN
    case TRANSFER_OUT
}
public class IsmTransaction  {
    
    public init(){}
    
    public var gid:String = ""
    public var name:String = ""
    public var amount:Double = 0.0
    public var date:Int = 0
    public var type:TransactionType = .OUTGOING  // 1: In coming 2: Out going 0: header
    public var checked:Int = 0
    public var typeEntry:TypeEntry = .EXPENSE
    
    //For header only
    public var initialBalance:Double = 0
    public var debit:Double = 0
    public var credit:Double = 0
    
}
