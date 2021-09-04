//
//  TimePicker.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 9/28/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import UIKit

public protocol TimeDelegate: class {
    func timeSelected(tag: Int, cancel:Bool)
}


public class TimePicker: UIDatePicker {
    public let toolBar = UIToolbar()
    public var timeFormat: String!
    typealias changedCallBack = (_ sender: UIDatePicker) -> Void
    
    var pickerListener: ((_ dateSelected: Date) -> Void)!
    
    
    public weak var delegate: TimeDelegate?
    
    public func setUp(widthSize:Int, heightSize:Int, selectedDate: Date, displayNow:Bool, format: String) {
        
        self.preferredDatePickerStyle = .wheels
        self.timeFormat = format
        self.date = selectedDate
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        
        // Set some of UIDatePicker properties
        self.timeZone = NSTimeZone.local
        self.datePickerMode = UIDatePicker.Mode.time
        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(TimePicker.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let nowButton = UIBarButtonItem(title: NSLocalizedString("text_now", comment: "Now"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(TimePicker.nowTimePicker))
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(TimePicker.cancleDatePicker))
        
        if displayNow {
            toolBar.setItems([cancelButton, spaceButton, nowButton, spaceButton1, doneButton], animated: false)
        }else {
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        }
        
        toolBar.isUserInteractionEnabled = true
    }
    
    public func setCurrentDate (currentDate: Date) {
        
        self.date = currentDate
    }
    
    @objc func doneDatePicker() {
        
        delegate?.timeSelected(tag: self.tag, cancel: false)
        
    }
    
    @objc func nowTimePicker() {
        self.date = Date()
        delegate?.timeSelected(tag: self.tag, cancel: false)
    }
    
    @objc func cancleDatePicker(){
        delegate?.timeSelected(tag: self.tag, cancel: true)
    }
    
    public func datePickerValueChanged(_ sender: UIDatePicker){
        
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = self.timeFormat//pref.getDateFormat()
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        self.pickerListener(sender.date)
        print("Selected value \(selectedDate)")
    }
    
    public func onDateSelected(listenerDate: @escaping (_ dateSelected: Date) -> Void) {
        
        self.pickerListener = listenerDate
    }
}
