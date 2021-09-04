//
//  AnalyticsViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/11/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase
import Charts
import ISMLDataService

class AnalyticsViewController: BaseScreenViewController, ChartViewDelegate {

    @IBOutlet weak var txtStartDate: TextFieldDateInput!
    @IBOutlet weak var txtEndDate: TextFieldDateInput!
    @IBOutlet weak var txtSpendingValue: NormalTextLabel!
    @IBOutlet weak var txtCategoryValue: NormalTextLabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var txtIncomeValue: NormalTextLabel!
    @IBOutlet weak var chartIncomesPie: PieChartView!
    
    
    
    var startDateSelector:DatePicker!
    var endDateSelector:DatePicker!
    
    var mTransactions:[IsmTransaction] = []
    var mIncomeTransactions:[IsmTransaction] = []
    var mExpenseTransactions:[IsmTransaction] = []
    var budgetsId:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        // Do any additional setup after loading the view.
        
      
        
        self.txtStartDate.tag = 1
        self.txtEndDate.tag = 2
        self.txtStartDate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        self.txtEndDate.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        startDateSelector = DatePicker()
        startDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200,
                                selectedDate: Date()
            ,inputText: self.txtStartDate as UITextField, inputTextErr: UILabel(), date_format: self.pref.getDateFormat())
        self.txtStartDate.inputView = startDateSelector
        self.txtStartDate.inputAccessoryView = startDateSelector.toolBar
        
        endDateSelector = DatePicker()
        endDateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 200,
                              selectedDate: Date()
            ,inputText: self.txtEndDate as UITextField, inputTextErr: UILabel(), date_format: self.pref.getDateFormat())
        self.txtEndDate.inputView = endDateSelector
        self.txtEndDate.inputAccessoryView = endDateSelector.toolBar
      
        let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: startDateSelector.date).timeIntervalSince1970)
        let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: endDateSelector.date).timeIntervalSince1970)
        
        self.txtSpendingValue.text = ""
        self.txtCategoryValue.text = ""
        self.txtIncomeValue.text = ""
        
        LineChart.setUpCharts(chart: lineChart)
        lineChart.delegate = self
        
        
        PieChart.setUpCharts(chart: pieChart)
        pieChart.delegate = self
        
        PieChart.setUpCharts(chart: chartIncomesPie)
        chartIncomesPie.delegate = self
        loadData()
    }
    
    func loadData() {
        budgetsId = []
        let fbBudget = FbBudget(reference: firestoreRef)
        fbBudget.getUserBudgets(user_gid: self.pref.getUserIdentifier(), onBudgetRead: { userOwnBugets in
            var count = 0
            for budget in userOwnBugets {
                if count > 9 {
                    continue
                }
                self.budgetsId.append(budget.budgetGid)
                count += 1
            }
            
            print(self.budgetsId)
            let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: self.startDateSelector.date).timeIntervalSince1970)
            let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: self.endDateSelector.date).timeIntervalSince1970)
            self.loadTransaction(start_date: start_data,  end_date: end_data, listGid: self.budgetsId)
            
        })
    }
    @objc func cancel(_ sender: UIBarButtonItem) {

        self.dismiss(animated: true, completion: nil)
    }

    
    func loadTransaction(start_date: Int, end_date: Int, listGid: [String]) {
    
        print(listGid)
        
        let start:String = UtilsIsm.dateFormatOrTimeFor(Date(timeIntervalSince1970: Double(start_date)), format: self.pref.getDateFormat())
        let end:String = UtilsIsm.dateFormatOrTimeFor(Date(timeIntervalSince1970: Double(end_date)), format: self.pref.getDateFormat())
        self.txtStartDate.text = start
        self.txtEndDate.text = end
        
    
        let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
        fbIncome.getIncomesForDates(userGid: self.pref.getUserIdentifier(), startDate: start_date, endDate: end_date,
                        complete: {(incomesList:[Income]) in
            
            self.mIncomeTransactions = []
            for income in incomesList {
                
                let transaction = IsmTransaction()
                
                transaction.name = income.title!
                transaction.date = income.transaction_date!
                transaction.amount = income.amount!
                transaction.type = .INCOMING
                
                self.mIncomeTransactions.append(transaction)
                
            }
            
            self.reloadChart()
            
        }, error_message: {(error) in
            print(error.errorMessage)
        })
        
//        fbIncome.getIncomesForBugdts(budgetGids: listGid, startDate: start_date, endDate: end_date,
//                        complete: {(incomesList:[Income]) in
//
//            self.mIncomeTransactions = []
//            for income in incomesList {
//
//                let transaction = IsmTransaction()
//
//                transaction.name = income.title!
//                transaction.date = income.transaction_date!
//                transaction.amount = income.amount!
//                transaction.type = .INCOMING
//
//                self.mIncomeTransactions.append(transaction)
//
//            }
//
//            self.reloadChart()
//
//        }, error_message: {(error) in
//            print(error.errorMessage)
//        })
//
        
        
        
        let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
        fbExpense.getExpensesForDates(userGid: self.pref.getUserIdentifier(), startDate: start_date, endDate: end_date,
                            complete: {(expensesList:[Expense]) in
            
            self.mExpenseTransactions = []
            for expense in expensesList {
                
                let transaction = IsmTransaction()
                
                transaction.name = expense.title!
                transaction.date = expense.transaction_date!
                transaction.amount = expense.amount!
                transaction.type = .OUTGOING
               
                self.mExpenseTransactions.append(transaction)
                
            }
            
            self.indicatorHide()
            self.reloadChart()
            
        }, error_message: {(error) in
            print(error)
        })
//        fbExpense.getExpensesForBudget(budgetGids: listGid, startDate: start_date, endDate: end_date,
//                            complete: {(expensesList:[Expense]) in
//
//            self.mExpenseTransactions = []
//            for expense in expensesList {
//
//                let transaction = IsmTransaction()
//
//                transaction.name = expense.title!
//                transaction.date = expense.transaction_date!
//                transaction.amount = expense.amount!
//                transaction.type = .OUTGOING
//
//                self.mExpenseTransactions.append(transaction)
//
//            }
//
//            self.indicatorHide()
//            self.reloadChart()
//
//        }, error_message: {(error) in
//            print(error)
//        })
    }
    
    func reloadChart(){
        self.mTransactions = []
        var totalIncome = 0.0
        var totalExpense = 0.0
        
        for transaction in mIncomeTransactions {
        
            self.mTransactions.append(transaction)
            
            totalIncome  += transaction.amount
        }
        
        
        for transaction in mExpenseTransactions {
            
            //transaction.amount = transaction.amount
            self.mTransactions.append(transaction)
            
            totalExpense  += transaction.amount
        }
        
        self.expenseChart()
        self.groupPieData()
        print(self.mTransactions)
    }
    
    func expenseChart() {
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
                
                
                LineChart.setUpChartWithData(chart: self.lineChart, chartData: dailyExpenses)
            }
        }
    }
    
    func groupPieData() {
        
        var incomeDataPoint = [String:DataPoint]()
        var expenseDataPoint = [String:DataPoint]()
        
        var expenseCatChart = [ChartDataEntry]()
        var incomeChart = [ChartDataEntry]()

        for tnx in mTransactions {
            if tnx.type == .INCOMING  {
                if incomeDataPoint[tnx.name] != nil {
                    let pie = incomeDataPoint[tnx.name]
                    pie?.value += tnx.amount
                    incomeDataPoint[tnx.name] = pie
                }else{
                    incomeDataPoint[tnx.name] = DataPoint(val: tnx.amount, date: tnx.name, tag: 1)
                }
            } else if tnx.type == .OUTGOING  {
                if expenseDataPoint[tnx.name] != nil {
                    let pie = expenseDataPoint[tnx.name]
                    pie?.value += tnx.amount
                    expenseDataPoint[tnx.name] = pie
                }else{
                    expenseDataPoint[tnx.name] = DataPoint(val: tnx.amount, date: tnx.name, tag: 1)
                }
            }
          
        }
        
        for (_,pie) in incomeDataPoint {
            var label = pie.dateText
            if label.count > 16 {
              label = "\(label.prefix(16))..."
            }
            let dataPoint1 = DataPoint(val: pie.value, date: pie.dateText, tag: 5)
            let entry = PieChartDataEntry(value: pie.value, label: label, data: dataPoint1)
            incomeChart.append(entry)
        }
        
        for (_,pie) in expenseDataPoint {
            var label = pie.dateText
            if label.count > 16 {
              label = "\(label.prefix(16))..."
            }
            let dataPoint1 = DataPoint(val: pie.value, date: pie.dateText, tag: 6)
            let entry = PieChartDataEntry(value: pie.value, label: label, data: dataPoint1)
            expenseCatChart.append(entry)
        }
        
        PieChart.setUpChartWithData(chart: self.pieChart, chartData: expenseCatChart,  centerText: "Expenses")
        PieChart.setUpChartWithData(chart: self.chartIncomesPie, chartData: incomeChart, centerText: "Incomes")
        
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
             let data  = entry.data as? DataPoint
             if data != nil {
           
                 let value = UtilsIsm.formartCurrency(value: data!.value, local: self.pref.getCurrency())
                 if data!.tag == 1 {
                     //self.selectedDayIncome.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 } else if data!.tag == 2 {
                     self.txtSpendingValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }else if data!.tag == 3 {
                     //self.selectedDayBalance.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }else if data!.tag == 4 {
                     //self.selectedDailyCumulative.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }else if data!.tag == 5 {
                     self.txtIncomeValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }else if data!.tag == 6 {
                     self.txtCategoryValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
                 }
                 
             }
             
         }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if Int(startDateSelector.date.timeIntervalSince1970) > Int(endDateSelector.date.timeIntervalSince1970) {

            startDateSelector.date  = startDateSelector.date
            endDateSelector.date = startDateSelector.date
            
            self.txtStartDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(startDateSelector.date.timeIntervalSince1970)), format: self.pref.getDateFormat())
            self.txtEndDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(startDateSelector.date.timeIntervalSince1970)), format: self.pref.getDateFormat())
            
        }
        
        let start_data:Int = Int(UtilsIsm.firstHourOfTheDay(varDate: startDateSelector.date).timeIntervalSince1970)
        let end_data:Int = Int(UtilsIsm.lastHourOfTheDay(varDate: endDateSelector.date).timeIntervalSince1970)
        self.loadTransaction(start_date: start_data,  end_date: end_data, listGid: budgetsId)
    }
}
