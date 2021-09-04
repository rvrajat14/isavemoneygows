//
//  MonthYearViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/18/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit

class MonthPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let months =  [NSLocalizedString("January", comment: "January"),
                   NSLocalizedString( "February", comment:  "February"),
                   NSLocalizedString( "March", comment:  "March"),
                   NSLocalizedString( "April", comment:  "April"),
                   NSLocalizedString( "May", comment:  "May"),
                   NSLocalizedString( "June", comment:  "June"),
                   NSLocalizedString( "July", comment:  "July"),
                   NSLocalizedString( "August", comment:  "August"),
                   NSLocalizedString( "September", comment:  "September"),
                   NSLocalizedString( "October", comment:  "October"),
                   NSLocalizedString( "November", comment:  "November"),
                   NSLocalizedString( "December", comment:  "December")]
    var years: [Int]!
    let toolBar = UIToolbar()
    var inputTxt:UITextField!
    var inputTxtError:UILabel!
    
    var month: Int = 0 {
        didSet {
            print("Month set \(month)")
            selectRow(month, inComponent: 0, animated: true)
        }
    }
    
    var year: Int = 0 {
        didSet {
            print("Year set \(year)")
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonSetup()
        
        
    }
    
    func commonSetup() {
        
        var years: [Int] = []
        if years.count == 0 {
            let year = (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).component(.year, from: Date())
            for index in 1...30 {
                let aYear:Int = year + index - 15
                years.append(aYear)
                //year += index - 15
            }
            
            
        }
        self.years = years
        
        self.delegate = self
        self.dataSource = self
        
        let month = (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).component(.month, from: Date())
        self.selectRow(month-1, inComponent: 0, animated: false)
         let defaultYear = (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).component(.year, from: Date())
        self.selectRow(years.index(of: defaultYear)!, inComponent: 1, animated: false)
        
        self.month = month - 1
        self.year = defaultYear
        
        print("Default values \(self.month) \(self.year)")
    
        
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0)
        let year = years[self.selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            block(month, year)
        }
        
        self.month = month
        self.year = year
    }
    
    /*func getSelectedMonth() -> String {
        
        return "\(self.month) \(self.year)"
    }*/
    
    func getSelectedMonth() -> Int {
        
        return self.month
    }
    func getSelectedYear() -> Int {
        
        return self.year
    }

    func setUp(inputText:UITextField, inputTextErr:UILabel)  {
        
        self.inputTxt = inputText
        self.inputTxtError = inputTextErr
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        self.showsSelectionIndicator = true
        
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(MonthPicker.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(MonthPicker.canclePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

    }
    
    @objc func donePicker(){
        
        
        print("done picking...")
        let selectedMonth = self.getSelectedMonth()
        let selectedYear = self.getSelectedYear()
        print("Selected values \(selectedMonth) \(selectedYear)")
        
        self.inputTxt.text = months[selectedMonth] + " " + String(selectedYear)
        self.inputTxt.layer.borderWidth = 0.0
        self.inputTxtError?.text = ""
        self.inputTxt.resignFirstResponder()
        
        
    }
    
    @objc func canclePicker(){
        print("cancel picking...")
        self.inputTxt.resignFirstResponder()
    }
    
    
}
