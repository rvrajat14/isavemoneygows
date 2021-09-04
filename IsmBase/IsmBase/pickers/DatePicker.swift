//
//  DatePicker.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/17/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public class DatePicker: UIDatePicker {

    public let toolBar = UIToolbar()
    typealias changedCallBack = (_ sender: UIDatePicker) -> Void
    var inputTxt:UITextField!
    var inputTxtError:UILabel!
    var todayDisplay = true
    var pickerListener: ((_ dateSelected: Date) -> Void)!
    var dateFormat:String = ""
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public func setUp(widthSize:Int, heightSize:Int, inputText:UITextField, inputTextErr:UILabel, today_display:Bool) {
        todayDisplay = today_display
        setUp(widthSize: widthSize, heightSize: heightSize, inputText: inputText, inputTextErr: inputTextErr)
    }
    public func setUp(widthSize:Int, heightSize:Int, inputText:UITextField, inputTextErr:UILabel) {
    
        self.inputTxt = inputText
        self.inputTxtError = inputTextErr
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        // Set some of UIDatePicker properties
        self.timeZone = NSTimeZone.local
        self.datePickerMode = UIDatePicker.Mode.date
        //datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        //self.addTarget(self, action: #selector(DatePicker.datePickerValueChanged(_:)), for: .valueChanged)
        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        
        
        //let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.cancleDatePicker))
        
        if todayDisplay {
            let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            
            let todayButton = UIBarButtonItem(title: NSLocalizedString("text_today", comment: "Today"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.todayDatePicker))
            
           
            toolBar.setItems([cancelButton, spaceButton, todayButton, spaceButton1, doneButton], animated: false)
            
        }else{
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        }
        
        toolBar.isUserInteractionEnabled = true
    }

    public func setUp(widthSize:Int, heightSize:Int, selectedDate: Date, inputText:UITextField, inputTextErr:UILabel) {
        
        self.date = selectedDate
        self.inputTxt = inputText
        self.inputTxtError = inputTextErr
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        
        // Set some of UIDatePicker properties
        self.timeZone = NSTimeZone.local
        self.datePickerMode = UIDatePicker.Mode.date
        //datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        //self.addTarget(self, action: #selector(DatePicker.datePickerValueChanged(_:)), for: .valueChanged)
        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        
        
        //let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let todayButton = UIBarButtonItem(title: NSLocalizedString("text_today", comment: "Today"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.todayDatePicker))
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.cancleDatePicker))
        
        toolBar.setItems([cancelButton, spaceButton, todayButton, spaceButton1, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    
    
    public func setUp(widthSize:Int, heightSize:Int, selectedDate: Date, minDate:Date, inputText:UITextField, inputTextErr:UILabel) {
        
        self.minimumDate = minDate
        self.date = selectedDate
        self.inputTxt = inputText
        self.inputTxtError = inputTextErr
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        
        // Set some of UIDatePicker properties
        self.timeZone = NSTimeZone.local
        self.datePickerMode = UIDatePicker.Mode.date
        //datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        //self.addTarget(self, action: #selector(DatePicker.datePickerValueChanged(_:)), for: .valueChanged)
        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        
        
        //let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let todayButton = UIBarButtonItem(title: NSLocalizedString("text_today", comment: "Today"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.todayDatePicker))
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.cancleDatePicker))
        
        toolBar.setItems([cancelButton, spaceButton, todayButton, spaceButton1, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    
    public func setUp(widthSize:Int, heightSize:Int, selectedDate: Date, maxDate:Date, inputText:UITextField, inputTextErr:UILabel) {
        
        self.maximumDate = maxDate
        self.date = selectedDate
        self.inputTxt = inputText
        self.inputTxtError = inputTextErr
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        
        // Set some of UIDatePicker properties
        self.timeZone = NSTimeZone.local
        self.datePickerMode = UIDatePicker.Mode.date
        //datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        //self.addTarget(self, action: #selector(DatePicker.datePickerValueChanged(_:)), for: .valueChanged)
        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        
        
        //let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let todayButton = UIBarButtonItem(title: NSLocalizedString("text_today", comment: "Today"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.todayDatePicker))
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DatePicker.cancleDatePicker))
        
        toolBar.setItems([cancelButton, spaceButton, todayButton, spaceButton1, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    public func setMinDate(date: Date){
    
        self.minimumDate = date
    }
    
    public func setMaxDate(date: Date){
        
        self.maximumDate = date
    }
    
    public func setSelected(date: Date){
        if (self.minimumDate?.timeIntervalSince1970)! <= date.timeIntervalSince1970 && date.timeIntervalSince1970 <= (self.maximumDate?.timeIntervalSince1970)! {
            
            self.date = date
        }else{
            
            self.date = self.minimumDate!
        }
        
    }
    @objc func doneDatePicker() {
        
        self.inputTxt.resignFirstResponder()
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = self.dateFormat.replacingOccurrences(of: "m", with: "M")
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: self.date)
        
        
        self.inputTxt.text = selectedDate
        self.inputTxt.layer.borderWidth = 0.0
        self.inputTxtError?.text = ""
        
       
    }
    
    @objc func todayDatePicker() {
    
        
        self.date = Date()
        self.inputTxt.resignFirstResponder()
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = self.dateFormat
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: self.date)
        
        
        self.inputTxt.text = selectedDate
        self.inputTxt.layer.borderWidth = 0.0
        self.inputTxtError?.text = ""
        
     
    }
    
    @objc func cancleDatePicker(){
        print("cancel picking...")
        self.inputTxt.resignFirstResponder()
    }
    
    public func datePickerValueChanged(_ sender: UIDatePicker){
        
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = dateFormat.replacingOccurrences(of: "m", with: "M")
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        
        self.inputTxt.text = selectedDate
        self.inputTxt.layer.borderWidth = 0.0
        self.inputTxtError?.text = ""
        
        
        self.pickerListener(sender.date)
        print("Selected value \(selectedDate)")
    }
    
    public func onDateSelected(listenerDate: @escaping (_ dateSelected: Date) -> Void) {
    
        self.pickerListener = listenerDate
    }

}
