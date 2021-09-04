//
//  PieChartViewController.swift
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
import FirebaseDatabase
import ISMLDataService
import ISMLBase

class PieChartViewController: BaseViewController, ChartViewDelegate {

    static var viewIdentifier:String = "PieChartViewController"
    
    var pieChartView: PieChartView!
    
    var textDateLabel: UILabel!
    var textAmountLabel: UILabel!
    var labelStackView: UIStackView!
//
//    var chartTabBarMenu: UITabBar!
//    var openBarChart: UITabBarItem!
//    var openLineChart: UITabBarItem!
//    var openPieChart: UITabBarItem!
    
    var contentWrapperStack: UIStackView!
    
    
    
    var ref: DatabaseReference!
    var pref:MyPreferences!
    var mBudget:Budget!
    
    var mCategories:[BudgetCategory] = []
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.setViewsLayout()
        
        pieChartView.delegate = self
        self.textAmountLabel.text = ""
        self.textDateLabel.text = ""
        
        self.pieChartView.chartDescription?.text = ""
        
        
        self.pieChartView.usePercentValuesEnabled = true
        
        self.pieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: ChartEasingOption.easeOutBack)
        
        self.pieChartView.noDataText = NSLocalizedString("chartPieNoData", comment: "No data available")
        self.pieChartView.isUserInteractionEnabled = true
        
        
        self.pieChartView.legend.horizontalAlignment = .left
        self.pieChartView.legend.verticalAlignment = .bottom
       
       
        
        // Do any additional setup after loading the view.
        
        self.ref = Database.database().reference()
        self.pref = MyPreferences()
        
//        self.chartTabBarMenu.delegate = self
        
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
//        navigationController?.navigationBar.isTranslucent = false
        
//        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(PieChartViewController.cancel(_:)))
//        self.navigationItem.leftBarButtonItem  = cancelButton
//        
//        
//        self.title = NSLocalizedString("chartPieTab", comment: "Title")
        
        //loadCurrentBudget()
        mBudget = appDelegate.budgetObject.formBudget()
        self.pullCategories(mBudget)
    }
    
    func setViewsLayout() {
        
        pieChartView = PieChartView()
        
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
            s.translatesAutoresizingMaskIntoConstraints = false
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
        self.view.addSubview(pieChartView)
        pieChartView.edgesToSuperview(insets: .top(30) + .bottom(0), usingSafeArea: true)
//        self.view.addSubview(chartTabBarMenu)
//        chartTabBarMenu.edgesToSuperview(excluding: .top, usingSafeArea: true)
        
    
    }

    func loadChart(categories: [BudgetCategory]){
    
    
        var yVals: [Double] = []
        
        for category in categories {
            
            yVals.append(category.spent)
        }
        
        var entries = [ ChartDataEntry]()
        var index = 0
        //for (i, v) in yVals.enumerated() {
            /*let entry = ChartDataEntry()
            entry.x = Double( i)
            entry.y = v*/
            //entry. = categories[index].title
            
          for category in categories {
            var label = category.title
            if category.title.count > 16 {
            
                label = "\(category.title.prefix(16))..."
                
                
            }
            let entry = PieChartDataEntry(value: category.spent, label: label, data: category)
            entries.append( entry)
            
            index += 1
        }
        
        
        
        // 3. chart setup
        let set = PieChartDataSet( entries: entries, label: NSLocalizedString("chartPieTab", comment: ""))
        // this is custom extension method. Download the code for more details.
        
        var circleColors = [NSUIColor]()
        
        let colorset = ColorsSet()
        
        var uiColorSet = colorset.getColors()
        
        index = 0
        for _ in yVals {
            
            
            circleColors.append(uiColorSet[index])
            index += 1
        }
        
        set.colors = circleColors
        
        /*let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        set.valueFormatter = formatter as? IValueFormatter*/
        
        let pieChartData = PieChartData( dataSet: set)
    
        pieChartView.data = pieChartData
        ///
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.data = pieChartData
        pieChartView.centerText = IsmUtils.makeTitleFor(budget: mBudget)
        pieChartView.chartDescription?.text = ""
        pieChartView.usePercentValuesEnabled = true
        pieChartView.legend.horizontalAlignment = .center
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.holeRadiusPercent = 0.55
        pieChartView.highlightPerTapEnabled = true
        pieChartView.animate(yAxisDuration: 2.0, easingOption: .easeInBack)
        
        
    }
    

    
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        appDelegate.navigateTo(instance: ViewController())
    }

    
    
    func pullCategories(_ budget: Budget) {
        
        let budgetObject = self.appDelegate.budgetObject
        
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
        
        self.loadChart(categories: self.mCategories)
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let category = entry.data as? BudgetCategory ?? BudgetCategory()
        //let index = Int(entry.x)
        
        //let category = self.mCategories[index]
        
        self.textDateLabel.text = category.title
        self.textAmountLabel.text = UtilsIsm.formartCurrency(value: category.spent, local: self.pref.getCurrency())

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
