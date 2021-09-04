//
//  PayerChartsViewController.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 01/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import Charts
import ISMLBase
import ISMLDataService
import FirebaseFirestore

class PayerChartsViewController: BaseScreenViewController, ChartViewDelegate {
    @IBOutlet weak var dailyTransactionsChart: LineChartView!
    @IBOutlet weak var dailyBalanceChart: LineChartView!
    @IBOutlet weak var dayExpenseVal: UILabel!
    
    @IBOutlet weak var cumulativeBalValue: UILabel!
    
    var incomes:[Income] = []
    var tabsViewController:PayerDetailTabsViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pref = MyPreferences()
        self.dayExpenseVal.text = ""
        self.cumulativeBalValue.text = ""
        self.tabsViewController = params["tabController"] as? PayerDetailTabsViewController ?? nil
        self.setUpCharts(chart: dailyTransactionsChart)
        self.setUpCharts(chart: dailyBalanceChart)
        if self.tabsViewController?.incomes != nil{
            self.incomes = self.tabsViewController!.incomes!
            //print("incomes")
            //print(self.incomes)
            self.initCharts()
        }else{
            self.initData(params["payer"] as? Payer ?? nil)
        }
        
    }
    
    private func initCharts(){
        self.groupData(onCompletion: {(dailyExpenses,dailyBalances) in
            self.setUpChartWithData(chart: self.dailyTransactionsChart, chartData: dailyExpenses)
            self.setUpChartWithData(chart: self.dailyBalanceChart, chartData: dailyBalances)
        })
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
    
    private func groupData(onCompletion: @escaping ([ChartDataEntry],[ChartDataEntry])->Void){
        DispatchQueue.global(qos: .background).async {
            var currentDate:String = ""
            var currentDateTransactions:Double = 0.0
            var dailyBalance:Double = 0.0
            var dailyExpenses:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var dailyBalances:[ChartDataEntry] = [ChartDataEntry(x: 0.0, y: 0.0)]
            var counter:Double = 1.0;
            for (index,income) in self.incomes.enumerated(){
                let date =  UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(income.transaction_date)), format: self.pref.getDateFormat())
                if date == currentDate{
                    currentDateTransactions += income.amount
                }else{
                    if currentDate != "" {
                        let dataPoint1 = DataPoint(val: currentDateTransactions, date: date, tag: 1);
                        dailyExpenses.append(ChartDataEntry(x: counter,
                                                            y: currentDateTransactions,
                                                             data: dataPoint1))
                        let dataPoint2 = DataPoint(val: dailyBalance, date: date, tag: 2);
                        dailyBalances.append(ChartDataEntry(x: counter, y: dailyBalance,
                                                            data: dataPoint2))
                        counter += 1.0
                    }
                    currentDate = date
                    currentDateTransactions = income.amount
                }
                dailyBalance += currentDateTransactions
                if index+1 == self.incomes.count{
                    let dataPoint1 = DataPoint(val: currentDateTransactions, date: date, tag: 1);
                    dailyExpenses.append(ChartDataEntry(x: counter, y: currentDateTransactions,
                                                        data: dataPoint1))
                    let dataPoint2 = DataPoint(val: dailyBalance, date: date, tag: 2);
                    dailyBalances.append(ChartDataEntry(x: counter, y: dailyBalance,
                                                        data: dataPoint2))
                }
            }
            
            DispatchQueue.main.async {
                onCompletion(dailyExpenses,dailyBalances)
            }
        }
    }
    private func initData(_ payer:Payer?){
        IncomesCollection(reference: Firestore.firestore()).getByPayerGid(payer?.gid ?? "", onComplete: {(incomes) in

            self.incomes = incomes
            self.initCharts()
            self.tabsViewController?.incomes = incomes
        }, onError: {(error) in


        })
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let data  = entry.data as? DataPoint
        if data != nil {
            
            let value = UtilsIsm.formartCurrency(value: data!.value, local: self.pref.getCurrency())
            if data!.tag == 1 {
                self.dayExpenseVal.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
            } else {
                self.cumulativeBalValue.text = "(\(String(describing: value))) \(String(describing: data!.dateText))"
            }
            
        }
        
    }

}

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}
