//
//  CompleteDatePicker.swift
//  ISMLBase
//
//  Created by ARMEL KOUDOUM on 9/26/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

public class CompleteDatePicker: UIDatePicker{
    
    public let toolBar = UIToolbar()
    typealias changedCallBack = (_ sender: UIDatePicker) -> Void
   
    var pickerListener: ((_ dateSelected: Date) -> Void)!

    var currentView:TextFieldDateInput!
   // public weak var delegate: DateDelegate?
    
    
    public func setUp(widthSize:Int, heightSize:Int, displayToday:Bool, associatedView: TextFieldDateInput) {
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        self.currentView = associatedView
        // Set some of UIDatePicker properties
        self.timeZone = NSTimeZone.local
        self.datePickerMode = UIDatePicker.Mode.date

        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        //let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let todayButton = UIBarButtonItem(title: NSLocalizedString("text_today", comment: "Today"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.todayDatePicker))
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelDatePicker))
        
        if displayToday {
            toolBar.setItems([cancelButton, spaceButton, todayButton, spaceButton1, doneButton], animated: false)
        } else {
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        }
        
        toolBar.isUserInteractionEnabled = true
        
        self.preferredDatePickerStyle = .wheels
        
        self.currentView.inputView = self
        self.currentView.inputAccessoryView = self.toolBar
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
        
        pickerListener(self.date)
        //delegate?.dateSelected(tag: self.tag, cancel: false)
        self.currentView.resignFirstResponder()
      
    }
    @objc func cancelDatePicker(){
        self.currentView.resignFirstResponder()
    }
    
    
    @objc func todayDatePicker() {
        
        self.date = Date()
        pickerListener(self.date)
        self.currentView.resignFirstResponder()
        
    }
    
    public func datePickerValueChanged(_ sender: UIDatePicker){
        
        pickerListener(self.date)
    }
    
    public func onDateSelected(listenerDate: @escaping (_ dateSelected: Date) -> Void) {
        
        self.pickerListener = listenerDate
    }
}
