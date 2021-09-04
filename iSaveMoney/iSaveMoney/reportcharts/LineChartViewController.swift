//
//  LineChartViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/10/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseFirestore
import TinyConstraints
import ISMLDataService
import ISMLBase

class LineChartViewController: BaseViewController, ChartViewDelegate {
    
    static var viewIdentifier:String = "LineChartViewController"

    
    var lineChartView: LineChartView!
    
    var textDateLabel: UILabel!
    var textAmountLabel: UILabel!
    var labelStackView: UIStackView!
    
//    var chartTabBarMenu: UITabBar!
//    var openBarChart: UITabBarItem!
//    var openLineChart: UITabBarItem!
//    var openPieChart: UITabBarItem!
    
    var contentWrapperStack: UIStackView!
    
    
    var firestoreRef: Firestore!
    var pref:MyPreferences!
    var mBudget:Budget!
    var months: [String]!
    var mExpenses:[Expense] = []
    
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        self.setViewsLayout()
        
        lineChartView.delegate = self
        
        self.lineChartView.xAxis.drawLabelsEnabled = false
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.xAxis.drawAxisLineEnabled = true
        self.lineChartView.xAxis.labelPosition = .bottom
        
        self.lineChartView.rightAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.drawGridLinesEnabled = false
        self.lineChartView.rightAxis.drawAxisLineEnabled = false
        self.lineChartView.rightAxis.drawLabelsEnabled = false
        
        self.lineChartView.chartDescription?.text = ""
        self.lineChartView.legend.enabled = false
        
        self.textAmountLabel.text = ""
        self.textDateLabel.text = ""
        
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()
        
        //self.chartTabBarMenu.delegate = self
//        
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
//        
//        navigationController?.navigationBar.isTranslucent = false
        
        
//        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(LineChartViewController.cancel(_:)))
//        self.navigationItem.leftBarButtonItem  = cancelButton
        
        
//        self.title = NSLocalizedString("chartLineTab", comment: "Title")
    
        
        self.pullExpenses()
        // Do any additional setup after loading the view.
    }

    
    func setViewsLayout() {
        
        lineChartView = LineChartView()
        
        textDateLabel = {
            let label = UILabel()
            label.text = "mm/dd/yyyy"
            label.textAlignment = .left
            label.textColor = Const.greyDarkColor
            label.font = UIFont(name: "Lato-Heavy", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        textAmountLabel = {
            let label = UILabel()
            label.text = "$2,000.00"
            label.textAlignment = .right
            label.textColor = Const.blueText
            label.font = UIFont(name: "Lato-Heavy", size: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        labelStackView = {
            let s = UIStackView(arrangedSubviews: [textDateLabel, textAmountLabel])
            s.axis = .horizontal
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.translatesAutoresizingMaskIntoConstraints = false
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        textDateLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor).isActive = true
        textAmountLabel.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor).isActive = true
        textDateLabel.widthAnchor.constraint(equalTo: textAmountLabel.widthAnchor).isActive = true
        textAmountLabel.leadingAnchor.constraint(equalTo: textDateLabel.trailingAnchor).isActive = true
        
        
        //tabItems
//        openBarChart = {
//            let t = UITabBarItem()
//            t.title = "Bar chart"
//            t.image = UIImage(named: "bar_chart")
//            t.tag = 0
//
//
//            return t
//        }()
//        openLineChart = {
//            let t = UITabBarItem()
//            t.title = "Pie Chart"
//            t.image = UIImage(named: "pie")
//            t.tag = 1
//            return t
//        }()
//        openPieChart = {
//            let t = UITabBarItem()
//            t.title = "Line Chart"
//            t.image = UIImage(named: "chart")
//            t.tag = 2
//            return t
//        }()
//
//        //tabItems end
//        self.chartTabBarMenu = {
//
//            let tabBar = UITabBar()
//            tabBar.height(50)
//            tabBar.setItems([openBarChart, openLineChart, openPieChart], animated: false)
//            return tabBar
//        }()
        
        self.view.addSubview(labelStackView)
        labelStackView.edgesToSuperview(excluding: .bottom, insets: .top(20) + .left(10) + .right(10), usingSafeArea: true)
        self.view.addSubview(lineChartView)
        lineChartView.edgesToSuperview(insets: .top(30) + .bottom(0), usingSafeArea: true)
//        self.view.addSubview(chartTabBarMenu)
//        chartTabBarMenu.edgesToSuperview(excluding: .top, usingSafeArea: true)
        
    }
    
    func groupeExpenses (expenses:[Expense]) -> [Expense] {
        
        var newExpensesSet:[Expense] = [Expense]()
        
        for expense in expenses {
            
            var found = false
            var index = 0
            let filterExpense = newExpensesSet
            newExpensesSet = []
            for oExpense in filterExpense {
                
                if oExpense.comment == expense.comment {
                    
                    found = true
                    oExpense.amount = oExpense.amount + expense.amount
                    newExpensesSet.append(oExpense)
                }else {
                    newExpensesSet.append(oExpense)
                }
                index += 1
            }
            
            if found == false {
                
                newExpensesSet.append(expense)
            }
            
        }
        
        return newExpensesSet
        
    }
    
    func loadChart(expenses:[Expense]) {
        
        
        var expensesSet = self.groupeExpenses(expenses: expenses)
        
        
        
        expensesSet = expensesSet.sorted(by: { $0.transaction_date! < $1.transaction_date! })
        
        if expensesSet.count > 0 {
            
            let expense = expensesSet[0]
            self.textAmountLabel.text = UtilsIsm.formartCurrency(value: expense.amount, local: self.pref.getCurrency())
            
            self.textDateLabel.text = expense.comment
        }
        
        
        
        if expensesSet.count <= 0 {
            
            self.lineChartView.noDataText = NSLocalizedString("chartLineNoData", comment: "No data available to display the chart.")
        }
        
        var yVals: [Double] =  []
        
        for expense in expensesSet {
            
            yVals.append(expense.amount)
            
        }
        
        //let yVals: [Double] = [ 873, 568, 937, 726, 696, 687, 180, 389, 90, 928, 890, 437]
        var entries = [ BarChartDataEntry]()
        var index = 0
        for (i, v) in yVals.enumerated() {
            
            let entry = BarChartDataEntry()
            entry.x = Double( i)
            entry.y = v
            entry.data = expensesSet[index]
            
            entries.append( entry)
            
            index += 1
        }
        
        
        // 3. chart setup
        let set = LineChartDataSet( entries: entries, label: NSLocalizedString("chartLineTab", comment: "Line Chart"))
        let data = LineChartData( dataSet: set)
        self.lineChartView.data = data
        
    }
    
    
    
    func pullExpenses(){
        
        
        let budgetObject = self.appDelegate.budgetObject
        
        self.mExpenses = []
        
        var totalExpenses = 0.0
        
        for (_, categoryObject) in (budgetObject?.categoriesDict)! {
            
            
            for (_, expense) in (categoryObject.expensesDict) {
                
                
                
                if expense.gid != "" {
                    expense.comment = UtilsIsm.ChartDateFormat(date:  Date(timeIntervalSince1970: Double(expense.transaction_date)))
                    
                    let firstHour =  UtilsIsm.firstHourOfTheDay(varDate: Date(timeIntervalSince1970: Double(expense.transaction_date)))
                    expense.transaction_date = Int(firstHour.timeIntervalSince1970)
                    self.mExpenses.append(expense)
                    totalExpenses += expense.amount
                }
                
            }
            
        }
        
        
        self.loadChart(expenses: self.mExpenses)
        
        
    }
    
    
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let expense = entry.data as! Expense
      
        
        self.textAmountLabel.text = UtilsIsm.formartCurrency(value: expense.amount, local: self.pref.getCurrency())
        
        self.textDateLabel.text = expense.comment

    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
       
//        appDelegate.navigateTo(instance: ViewController())
    }
    


    
}
