//
//  ChartsViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/4/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseFirestore
import TinyConstraints
import ISMLDataService
import ISMLBase

class BarchartDailyViewController: BaseViewController, ChartViewDelegate {

    static var viewIdentifier:String = "ChartsViewController"
    
    var barChartView: BarChartView!
    
    var textDateLabel: UILabel!
    var textAmountLabel: UILabel!
    var labelStackView: UIStackView!
    
//    var chartTabBarMenu: UITabBar!
//    var openBarChart: UITabBarItem!
//    var openLineChart: UITabBarItem!
//    var openPieChart: UITabBarItem!
    
    var contentWrapperStack: UIStackView!
    
    // @IBOutlet weak var barChartView: BarChartView!

    var firestoreRef:Firestore!
    var pref:MyPreferences!
    var mBudgetObject:BudgetObject!
    
    var months: [String]!
    var mExpenses:[Expense] = []

    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        mBudgetObject = params["mBudgetObject"] as? BudgetObject ?? nil
        self.setViewsLayout()
        
        self.barChartView.noDataText = NSLocalizedString("chartsLoadingData", comment: "Please wait. Loading data...")
        self.barChartView.delegate = self
        
        self.textAmountLabel.text = ""
        self.textDateLabel.text = ""
        
        self.barChartView.xAxis.drawLabelsEnabled = false
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.drawAxisLineEnabled = true
        self.barChartView.xAxis.labelPosition = .bottom
        
        self.barChartView.rightAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.drawAxisLineEnabled = false
        self.barChartView.rightAxis.drawLabelsEnabled = false
        
        self.barChartView.chartDescription?.text = ""
        self.barChartView.legend.enabled = false
        
        
        //
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()
        
//        self.chartTabBarMenu.delegate = self
        
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
//        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
//        navigationController?.navigationBar.isTranslucent = false
//        
        
//        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(BarchartDailyViewController.cancel(_:)))
//        self.navigationItem.leftBarButtonItem  = cancelButton
//
//        
//        self.title = NSLocalizedString("chartsBarTab", comment: "Title")
        
        self.pullExpenses()
        
        
    
    }
    
    func setViewsLayout() {
        
        barChartView = BarChartView()
        
        textDateLabel = {
            let label = UILabel()
            label.text = "mm/dd/yyyy"
            label.textAlignment = .left
            label.textColor = Const.greyDarkColor
            label.font = UIFont(name: "Lato-Heavy", size: 12)
            return label
        }()
        textAmountLabel = {
            let label = UILabel()
            label.text = "$2,000.00"
            label.textAlignment = .right
            label.textColor = Const.blueText
            label.font = UIFont(name: "Lato-Heavy", size: 14)
            return label
        }()
        labelStackView = {
            let s = UIStackView(arrangedSubviews: [textDateLabel, textAmountLabel])
            s.axis = .horizontal
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
       
        
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
        self.view.addSubview(barChartView)
        barChartView.edgesToSuperview(insets: .top(30) + .bottom(0), usingSafeArea: true)
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
                
                if oExpense.comment! == expense.comment! {
                
                    found = true
                    oExpense.amount = oExpense.amount! + expense.amount!
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
        
            self.barChartView.noDataText = NSLocalizedString("chartsNoData", comment: "No data avalaible for the chart.")
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
        let set = BarChartDataSet( entries: entries, label: NSLocalizedString("chartsBarTab", comment: "Bar Chart"))
    
        //NSLocalizedString("chartsBarTab", comment: "Bar Chart")
        let data = BarChartData( dataSet: set)
        self.barChartView.data = data
       
        
    }
    


    
   
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let expense = entry.data as! Expense
        
        
        self.textAmountLabel.text = UtilsIsm.formartCurrency(value: expense.amount, local: self.pref.getCurrency())
        
        self.textDateLabel.text = expense.comment
            //Utils.ChartDateFormat(date: Date(timeIntervalSince1970: Double(expense.transaction_date)))
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
    
    
    func loadCurrentBudget() {
        
        //load budget
        
        //let currentBudget = pref.getSelectedMonthlyBudget()
        
       /* let fbBudget = FbBudget(reference: self.firestoreRef)
        //
        
        
        if appDelegate.budgetObject.formBudget().gid != "" {// if preference gid exists
            
            fbBudget.get(appDelegate.budgetObject.formBudget().gid, completed: {(budget) in
                print(budget.toAnyObject())
                
                if budget.gid != "" { // if preference budget found
                    
                    //self.mBudget = mBudgetObject.formBudget()
                    
                    self.pullExpenses()
                    
                }
            }, not_found: { (message) in
                
                print(message)
                
            })
            
        }*/
        
        
    }
    
    
    //cancel
    @objc func cancel(_ sender: UIBarButtonItem) {
        //self.dismissViewController()
        appDelegate.navigateTo(instance: ViewController())
    }
  
    
    
//    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        
//        
//        //item.tag
//        switch item.tag {
//        case 0:
//            
//            appDelegate.navigateTo(instance: RChartsViewController())
//            print("ChartsViewController")
//            break
//        case 1:
//            
//            appDelegate.navigateTo(instance: PieChartViewController())
//            print("PieChartViewController")
//            
//            break
//        case 2:
//            
//            appDelegate.navigateTo(instance: LineChartViewController())
//            print("LineChartViewController")
//            break
//        default:
//            break
//        }
//        
//        
//    }
    

}
