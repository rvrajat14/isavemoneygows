//
//  OrderProcess.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/7/20.
//

import Foundation
import StoreKit

class OrderProcess{

        
    public static func convertTransaction(purchases: [SKPaymentTransaction]) -> [Section] {
        
        var transactionsDetails = [Section]()
        for paymentTransaction in purchases {
            let paymentTransactionDate = [DateFormatter.short(paymentTransaction.transactionDate!)]
            transactionsDetails = [Section(type: .productIdentifier, elements: [paymentTransaction.payment.productIdentifier]),
                                              Section(type: .transactionIdentifier, elements: [paymentTransaction.transactionIdentifier!]),
                                              Section(type: .transactionDate, elements: paymentTransactionDate)]
        }
        return transactionsDetails
    }
}
