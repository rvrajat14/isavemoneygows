//
//  CalendarPicker.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/5/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public protocol DateDelegate: class {
    func dateSelected(tag: Int, cancel:Bool)
}


public class CalendarPicker: UIDatePicker {
    
    public let toolBar = UIToolbar()
    typealias changedCallBack = (_ sender: UIDatePicker) -> Void
    var dateFormat: String = "dd/MM/yyyy"
   
    var pickerListener: ((_ dateSelected: Date) -> Void)!

    
    public weak var delegate: DateDelegate?
    
    
    public func setUp(widthSize:Int, heightSize:Int, selectedDate: Date, displayToday:Bool, dformat: String) {
        
        self.dateFormat = dformat
        self.date = selectedDate

        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        
        // Set some of UIDatePicker properties
        self.timeZone = NSTimeZone.local
        self.datePickerMode = UIDatePicker.Mode.date

        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        
        
        //let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(CalendarPicker.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let todayButton = UIBarButtonItem(title: NSLocalizedString("text_today", comment: "Today"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(CalendarPicker.todayDatePicker))
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(CalendarPicker.cancelDatePicker))
        
        if displayToday {
            toolBar.setItems([cancelButton, spaceButton, todayButton, spaceButton1, doneButton], animated: false)
        } else {
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        }
        
        toolBar.isUserInteractionEnabled = true
        
        self.preferredDatePickerStyle = .wheels
    }
    
    
    public func setCurrentDate (currentDate: Date) {
        
        self.date = currentDate
    }
    
    
    public func setMinDate(date: Date){
        
        self.minimumDate = date
    }
    
    public func setMaxDate(date: Date){
        
        self.maximumDate = date
    }
    
    @objc func doneDatePicker() {
        
        delegate?.dateSelected(tag: self.tag, cancel: false)
      
    }
    
    @objc func cancelDatePicker(){
        delegate?.dateSelected(tag: self.tag, cancel: true)
    }
    
    @objc func todayDatePicker() {
        
        self.date = Date()
        delegate?.dateSelected(tag: self.tag, cancel: false)
        
    }
    
    public func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = self.dateFormat
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        self.pickerListener(sender.date)
        print("Selected value \(selectedDate)")
    }
    
    public func onDateSelected(listenerDate: @escaping (_ dateSelected: Date) -> Void) {
        
        self.pickerListener = listenerDate
    }
    
}

