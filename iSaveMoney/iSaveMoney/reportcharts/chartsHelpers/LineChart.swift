//
//  LineChart.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 9/9/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import Charts
import ISMLBase

class LineChart {
    
    public static func setUpCharts(chart:LineChartView){
        //chart.delegate = self
        chart.noDataText = NSLocalizedString("chartLineNoData", comment: "No data available to display the chart.")
        chart.setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
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
    
    public static func setUpChartWithData(chart:LineChartView, chartData:[ChartDataEntry]){
    
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
}
