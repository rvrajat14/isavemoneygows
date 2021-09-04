//
//  SwiftyTableViewCellDelegate.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 10/14/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
protocol SwiftyTableViewCellDelegate : class {
    func swiftyTableViewCellDidTapAdd(_ sender: ExpenseTableViewCell)
}


protocol IncomeEditTableViewDelegate: class {
    func incomeEditTableViewCellDidTaped(_ sender: IcomeEditTableViewCell)
}

protocol ExpenseEditTableViewDelegate: class {
    func expenseEditTableViewCellDidTaped(_ sender: ExpenseEditTableViewCell)
}

