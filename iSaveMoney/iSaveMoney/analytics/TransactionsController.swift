//
//  TransactionsController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 11/22/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class TransactionsController: UIViewController {

    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var labelExpense: UILabel!
    @IBOutlet weak var labelIncome: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var tableTransactions: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
