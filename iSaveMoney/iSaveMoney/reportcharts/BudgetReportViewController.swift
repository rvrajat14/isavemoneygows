//
//  BudgetReportViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 9/9/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import Charts
import ISMLDataService
import ISMLBase

class BudgetReportViewController: BaseScreenViewController, ChartViewDelegate {

    @IBOutlet weak var selectedDaySpending: NormalTextLabel!
    @IBOutlet weak var dailySpendingLine: LineChartView!
    @IBOutlet weak var selectedDayIncome: NormalTextLabel!
    @IBOutlet weak var dailyIncomeLine: LineChartView!
    @IBOutlet weak var selectedDayBalance: NormalTextLabel!
    @IBOutlet weak var dailyBalanceLine: LineChartView!
    @IBOutlet weak var selectedDailyCumulative: NormalTextLabel!
    @IBOutlet weak var dailyCumulativeLine: LineChartView!
    @IBOutlet weak var spendingPerCategoryValue: NormalTextLabel!
    @IBOutlet weak var spendingPerCategoryPie: PieChartView!
    @IBOutlet weak var incomePerCategoryValue: NormalTextLabel!
    @IBOutlet weak var incomePerCategoryPie: PieChartView!
    
    
    lazy var cancelButton:UIBarButtonItem = {
           return UIBarButtonItem(image: UIImage(named: "back_icon"),
                                  landscapeImagePhone: UIImage(named: "back_icon"),
                                  style: .plain,
                                  target: self,
                                  action: #selector(PayeeFormViewController.cancel(_:)))
       }()
    var mTransactions:[IsmTransaction] = []
    var mCategories:[BudgetCategory] = []
    var totalExpenses: Double = 0.0
    var totalIncomes: Double = 0.0
    var budgetObject:BudgetObject!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("LineChart", comment: "Line Chart")
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        self.selectedDayIncome.text = ""
        self.selectedDaySpending.text = ""
        self.selectedDayBalance.text = ""
        self.selectedDailyCumulative.text = ""
        self.spendingPerCategoryValue.text = ""
        self.incomePerCategoryValue.text = ""
        
        budgetObject = self.appDelegate.budgetObject
        self.pullExpenses()
        self.pullIncomes()
        self.pullCategories()
        mTransactions = mTransactions.sorted(by: { $0.date < $1.date })
        // Do any additional setup after loading the view.
        LineChart.setUpCharts(chart: dailyIncomeLine)
        dailyIncomeLine.delegate = self
        LineChart.setUpCharts(chart: dailySpendingLine)
        dailySpendingLine.delegate = self
        LineChart.setUpCharts(chart: dailyBalanceLine)
        dailyBalanceLine.delegate = self
        LineChart.setUpCharts(chart: dailyCumulativeLine)
        dailyCumulativeLine.delegate = self
        
    
        self.groupData(onCompletion: {(dailyIncomes,dailyExpenses,dailyBalances, cumulativeSpending) in
            LineChart.setUpChartWithData(chart: self.dailyIncomeLine, chartData: dailyIncomes)
            LineChart.setUpChartWithData(chart: self.dailySpendingLine, chartData: dailyExpenses)
            LineChart.setUpChartWithData(chart: self.dailyBalanceLine, chartData: dailyBalances)
            LineChart.setUpChartWithData(chart: self.dailyCumulativeLine, chartData: cumulativeSpending)
        })
        
        PieChart.setUpCharts(chart: spendingPerCategoryPie)
        spendingPerCategoryPie.delegate = self
        PieChart.setUpCharts(chart: incomePerCategoryPie)
        incomePerCategoryPie.delegate = self
        self.groupPieData(onCompletion: {(categoryExpense, incomesGroup) in
            PieChart.setUpChartWithData(chart: self.spendingPerCategoryPie, chartData: categoryExpense,  centerText: "Expenses")
            PieChart.setUpChartWithData(chart: self.incomePerCategoryPie, chartData: incomesGroup, centerText: "Incomes")
        })
    }


    func pullExpenses(){
        
        self.totalExpenses = 0.0
        for (_, categoryObject) in (budgetObject.categoriesDict) {
            for (_, expense) in (categoryObject.expensesDict) {
                if expense.gid != "" {
                    let tnx = IsmTransaction();
                    tnx.gid = expense.gid
                    tnx.date = expense.transaction_date
                    tnx.type = .OUTGOING
                    tnx.name = expense.title
                    tnx.amount = expense.amount
                    self.mTransactions.append(tnx)
                }
            }
        }
        
    }
    func pullIncomes() {
        self.totalIncomes = 0.0
        for (_, income) in (budgetObject.incomesDict) {
            let tnx = IsmTransaction();
            tnx.gid = income.gid
            tnx.date = income.transaction_date
            tnx.type = .INCOMING
            tnx.name = income.title
            tnx.amount = income.amount
            self.mTransactions.append(tnx)
        }
    
    }
    func pullCategories() {
        for (_, categoryObject) in (budgetObject?.categoriesDict)! {
            let category:BudgetCategory = categoryObject.getCategory()
            var totalCategory = 0.0
            for (_, expense) in (categoryObject.expensesDict) {
                totalCategory +=  expense.amount
            }
            category.spent = totalCategory
            if totalCategory > 0 {
                self.mCategories.append(category)
            }
        }
    }
    
    
    
    
    private func groupData(onCompletion: @escaping ([ChartDataEntry],[ChartDataEntry],[ChartDataEntry],[ChartDataEntry])->Void){
        DispatchQueue.global(qos: .background).async {
            var currentDate:String = ""
            var currentDateIncomes:Double = 0.0
            var currentDateExpenses:Double = 0.0
            var dailyBalance:Double = 0.0
            var totalExpense:Double = 0.0
            var dailyIncomes:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var dailyExpenses:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var dailyBalances:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var cumulativeSpending:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var counter:Double = 1.0;
            for (index,transaction) in self.mTransactions.enumerated(){
                let date =  UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(transaction.date)), format: self.pref.getDateFormat())
                if date == currentDate{
                    if transaction.type == TransactionType.OUTGOING {
                        currentDateExpenses += transaction.amount
                        totalExpense += transaction.amount
                    }else if transaction.type == TransactionType.INCOMING{
                        currentDateIncomes += transaction.amount
                    }
                }else{
                    if currentDate != "" {
                        let dataPoint1 = DataPoint(val: currentDateIncomes, date: date, tag: 1)
                        let dataPoint2 = DataPoint(val: currentDateExpenses, date: date, tag: 2)
                        let dataPoint3 = DataPoint(val: dailyBalance, date: date, tag: 3)
                        let dataPoint4 = DataPoint(val: totalExpense, date: date, tag: 4)
                        dailyIncomes.append(ChartDataEntry(x: counter, y: currentDateIncomes, data: dataPoint1))
                        dailyExpenses.append(ChartDataEntry(x: counter, y: currentDateExpenses, data: dataPoint2))
                        dailyBalances.append(ChartDataEntry(x: counter, y: dailyBalance, data: dataPoint3))
                        cumulativeSpending.append(ChartDataEntry(x: counter, y: totalExpense, data: dataPoint4))
                        counter += 1.0
                    }
                    currentDate = date
                    if transaction.type == TransactionType.OUTGOING {
                        currentDateExpenses = transaction.amount
                        totalExpense += transaction.amount
                        currentDateIncomes = 0.0
                    }else if transaction.type == TransactionType.INCOMING{
                        currentDateIncomes = transaction.amount
                        currentDateExpenses = 0.0
                    }
                }
                dailyBalance += (currentDateIncomes - currentDateExpenses)
                if index+1 == self.mTransactions.count{
                    let dataPoint1 = DataPoint(val: currentDateIncomes, date: date, tag: 1)
                    let dataPoint2 = DataPoint(val: currentDateExpenses, date: date, tag: 2)
                    let dataPoint3 = DataPoint(val: dailyBalance, date: date, tag: 3)
                    let dataPoint4 = DataPoint(val: totalExpense, date: date, tag: 4)
                    dailyIncomes.append(ChartDataEntry(x: counter, y: currentDateIncomes, data: dataPoint1))
                    dailyExpenses.append(ChartDataEntry(x: counter, y: currentDateExpenses, data: dataPoint2))
                    dailyBalances.append(ChartDataEntry(x: counter, y: dailyBalance, data: dataPoint3))
                    cumulativeSpending.append(ChartDataEntry(x: counter, y: totalExpense, data: dataPoint4))
                }
            }
            
            DispatchQueue.main.async {
                onCompletion(dailyIncomes,dailyExpenses,dailyBalances, cumulativeSpending)
            }
        }
    }
    func groupPieData(onCompletion: @escaping ([ChartDataEntry],[ChartDataEntry])->Void) {
        var expenseCatChart = [ChartDataEntry]()
        var incomeChart = [ChartDataEntry]()
        for category in mCategories {
            var label = category.title
            if category.title.count > 16 {
                label = "\(category.title.prefix(16))..."
            }
            let dataPoint1 = DataPoint(val: category.spent, date: label ?? "", tag: 5)
            let entry = PieChartDataEntry(value: category.spent, label: label, data: dataPoint1)
            expenseCatChart.append( entry)
        }
        
        for tnx in mTransactions {
            if(tnx.type == .INCOMING) {
                var label = tnx.name
                if label.count > 16 {
                  label = "\(label.prefix(16))..."
                }
                let dataPoint1 = DataPoint(val: tnx.amount, date: label, tag: 6)
                let entry = PieChartDataEntry(value: tnx.amount, label: label, data: dataPoint1)
                incomeChart.append(entry)
            }
          
        }
        
        onCompletion(expenseCatChart, incomeChart)
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
             let data  = entry.data as? DataPoint
             if data != nil {
                 
                 let value = UtilsIsm.formartCurrency(value: data!.value, local: self.pref.getCurrency())
                 if data!.tag == 1 {
                     self.selectedDayIncome.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 } else if data!.tag == 2 {
                     self.selectedDaySpending.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }else if data!.tag == 3 {
                     self.selectedDayBalance.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }else if data!.tag == 4 {
                     self.selectedDailyCumulative.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }else if data!.tag == 5 {
                     self.spendingPerCategoryValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }else if data!.tag == 6 {
                     self.incomePerCategoryValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }
                 
             }
             
         }

}
