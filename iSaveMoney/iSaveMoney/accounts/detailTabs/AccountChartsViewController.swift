//
//  AccountChartsViewController.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 15/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import Charts
import ISMLDataService
import ISMLBase

class AccountChartsViewController: BaseScreenViewController, ChartViewDelegate{
    

    @IBOutlet weak var dailyBalanceChart: LineChartView!
    @IBOutlet weak var comingOutDailyChart: LineChartView!
    @IBOutlet weak var comingInDailyChart: LineChartView!
    
    @IBOutlet weak var cashInValue: UILabel!
    @IBOutlet weak var cashoutValue: UILabel!
    @IBOutlet weak var balanceValue: UILabel!
    
    
    var mAccount:Account?
    var mTransactions:[IsmTransaction] = []
    var tabsViewController:AccountTabsViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabsViewController = params["tabController"] as? AccountTabsViewController ?? nil
        mAccount = params["account"] as? Account ?? nil
        self.setUpCharts(chart: dailyBalanceChart)
        self.setUpCharts(chart: comingInDailyChart)
        self.setUpCharts(chart: comingOutDailyChart)
        if self.tabsViewController?.mTransactions != nil{
            self.mTransactions = self.tabsViewController!.mTransactions!
            self.initCharts()
        }else{
            self.loadData()
        }
        
        self.cashInValue.text = ""
        self.cashoutValue.text = ""
        self.balanceValue.text = ""
    }
    
    private func loadData(){
        AccountObject(fireRef: firestoreRef).loadData(account_gid: mAccount!.gid, dataSetChanged: {(transactions, account) in
            self.mTransactions = transactions.sorted(by: { $0.date>$1.date })
            if self.mTransactions.count > 0 {
                self.tabsViewController?.mTransactions = self.mTransactions
            }
            self.initCharts()
        })
    }
    
    private func initCharts(){
        self.groupData(onCompletion: {(dailyIncomes,dailyExpenses,dailyBalances) in
            self.setUpChartWithData(chart: self.comingInDailyChart, chartData: dailyIncomes)
            self.setUpChartWithData(chart: self.comingOutDailyChart, chartData: dailyExpenses)
            self.setUpChartWithData(chart: self.dailyBalanceChart, chartData: dailyBalances)
        })
    }
    
    private func groupData(onCompletion: @escaping ([ChartDataEntry],[ChartDataEntry],[ChartDataEntry])->Void){
        DispatchQueue.global(qos: .background).async {
            var currentDate:String = ""
            var currentDateIncomes:Double = 0.0
            var currentDateExpenses:Double = 0.0
            var dailyBalance:Double = 0.0
            var dailyIncomes:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var dailyExpenses:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var dailyBalances:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var counter:Double = 1.0;
            for (index,transaction) in self.mTransactions.enumerated(){
                let date =  UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(transaction.date)), format: self.pref.getDateFormat())
                if date == currentDate{
                    if transaction.type == TransactionType.OUTGOING {
                        currentDateExpenses += transaction.amount
                    }else if transaction.type == TransactionType.INCOMING{
                        currentDateIncomes += transaction.amount
                    }
                }else{
                    if currentDate != "" {
                        let dataPoint1 = DataPoint(val: currentDateIncomes, date: date, tag: 1);
                        let dataPoint2 = DataPoint(val: currentDateExpenses, date: date, tag: 2);
                        let dataPoint3 = DataPoint(val: dailyBalance, date: date, tag: 3);
                        dailyIncomes.append(ChartDataEntry(x: counter, y: currentDateIncomes, data: dataPoint1))
                        dailyExpenses.append(ChartDataEntry(x: counter, y: currentDateExpenses, data: dataPoint2))
                        dailyBalances.append(ChartDataEntry(x: counter, y: dailyBalance, data: dataPoint3))
                        counter += 1.0
                    }
                    currentDate = date
                    if transaction.type == TransactionType.OUTGOING {
                        currentDateExpenses = transaction.amount
                        currentDateIncomes = 0.0
                    }else if transaction.type == TransactionType.INCOMING{
                        currentDateIncomes = transaction.amount
                        currentDateExpenses = 0.0
                    }
                }
                dailyBalance += (currentDateIncomes - currentDateExpenses)
                if index+1 == self.mTransactions.count{
                    let dataPoint1 = DataPoint(val: currentDateIncomes, date: date, tag: 1);
                    let dataPoint2 = DataPoint(val: currentDateExpenses, date: date, tag: 2);
                    let dataPoint3 = DataPoint(val: dailyBalance, date: date, tag: 3);
                    dailyIncomes.append(ChartDataEntry(x: counter, y: currentDateIncomes, data: dataPoint1))
                    dailyExpenses.append(ChartDataEntry(x: counter, y: currentDateExpenses, data: dataPoint2))
                    dailyBalances.append(ChartDataEntry(x: counter, y: dailyBalance, data: dataPoint3))
                }
            }
            
            DispatchQueue.main.async {
                onCompletion(dailyIncomes,dailyExpenses,dailyBalances)
            }
        }
    }
    
    

    private func setUpCharts(chart:LineChartView){
        chart.delegate = self
        chart.setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
        //chart.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        chart.dragEnabled = true
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
        chart.maxHighlightDistance = 300
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled=false
        
        //chart.leftAxis.enabled=false
        //chart.legend.enabled = false
        chart.animate(xAxisDuration: 1, yAxisDuration: 1)
        
        chart.xAxis.drawLabelsEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawAxisLineEnabled = true
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.enabled = true
        
       
        
        chart.rightAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawLabelsEnabled = true
        chart.chartDescription?.text = ""
        chart.legend.enabled = false
    }
    
    private func setUpChartWithData(chart:LineChartView, chartData:[ChartDataEntry]){
    
        let set1 = LineChartDataSet(entries: chartData, label: "")
        set1.mode = .cubicBezier
        set1.axisDependency = .left
        set1.colors = [Const.background1]//[UIColor(red: 1.00, green: 0.40, blue: 0.43, alpha: 1.00)]
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2.0
        set1.circleRadius = 3.0
        set1.fillAlpha = 0.5
        set1.drawFilledEnabled = true
        set1.highlightColor = Const.INFO_GREEN//UIColor.blue
        set1.fillColor = Const.background2//UIColor(red: 1.00, green: 0.82, blue: 0.87, alpha: 1.00)
        set1.drawCircleHoleEnabled = false
        
        let data = LineChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 9)!)
        data.setDrawValues(false)
        
        chart.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
          let data  = entry.data as? DataPoint
          if data != nil {
              
              let value = UtilsIsm.formartCurrency(value: data!.value, local: self.pref.getCurrency())
              if data!.tag == 1 {
                  self.cashInValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
              } else if data!.tag == 2 {
                  self.cashoutValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
              }else if data!.tag == 3 {
                  self.balanceValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
              }
              
          }
          
      }

}
