//
//  AccountTransactionTableViewCellDelegate.swift
//  iSaveMoneyAcc
//
//  Created by ARMEL KOUDOUM on 8/6/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
protocol AccountTransactionTableViewCellDelegate: class {
    func accountTransactionTableViewCellDidTaped(_ sender: AccountTransactionTableViewCell, position:Int)
}
