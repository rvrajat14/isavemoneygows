//
//  PieChart.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 9/9/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import Charts
import ISMLBase

class PieChart {
    
    public static func setUpCharts(chart:PieChartView){
        //chart.delegate = self
        chart.chartDescription?.text = ""
        chart.usePercentValuesEnabled = true
        chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: ChartEasingOption.easeOutBack)
        chart.noDataText = NSLocalizedString("chartPieNoData", comment: "No data available")
        chart.isUserInteractionEnabled = true
        chart.legend.horizontalAlignment = .left
        chart.legend.verticalAlignment = .bottom
    }
    
    public static func setUpChartWithData(chart:PieChartView, chartData:[ ChartDataEntry], centerText: String) {

        let set = PieChartDataSet( entries: chartData, label: NSLocalizedString("chartPieTab", comment: ""))
        // this is custom extension method. Download the code for more details.
        var circleColors = [NSUIColor]()
        let colorset = ColorsSet()
        let uiColorSet = colorset.getColors()
        
        var index = 0
        for _ in chartData {
            circleColors.append(uiColorSet[index])
            index += 1
        }
        
        set.colors = circleColors
        let pieChartData = PieChartData( dataSet: set)
        chart.data = pieChartData
        ///
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chart.data = pieChartData
        chart.centerText = centerText
        chart.chartDescription?.text = ""
        chart.usePercentValuesEnabled = true
        chart.legend.horizontalAlignment = .center
        chart.drawEntryLabelsEnabled = false
        chart.holeRadiusPercent = 0.55
        chart.highlightPerTapEnabled = true
        chart.animate(yAxisDuration: 2.0, easingOption: .easeInBack)
    }
}
