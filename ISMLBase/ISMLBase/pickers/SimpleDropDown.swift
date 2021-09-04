//
//  SimpleDropDown.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/15/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import Foundation
import UIKit

public class SimpleDropDown: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var inputTxt:UITextField!
    var inputTxtError:UILabel!
    var mItems:[String] = []
    public var mSelectedItem:Int = -1
    public let toolBar = UIToolbar()
    var borderColor: CGColor!
    
    // Mark: UIPicker Delegate / Data Source
    
    var title:Int = 0 {
        didSet {
            
            selectRow(title, inComponent: 0, animated: true)
        }
    }
    
    var onTitleSelected: ((_ title: Int) -> Void)?
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("numberOfComponents 1")
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("titleForRow \(row)")
        return mItems[row]
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        print("numberOfRowsInComponent \(mItems.count)")
        return mItems.count
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        mSelectedItem = row
    }
    
    public func getId() -> Int {
        
        if self.mSelectedItem != -1 {
            
            return mSelectedItem
        } else {
            return 0
        }
    }
    
    
    
    public func getTitle() -> String {
        
        if self.mSelectedItem != -1 && mItems.count > 0 {
            
            return mItems[mSelectedItem]
        } else {
            
            return ""
        }
    }
    
    
    public func setUp(widthSize:Int, heightSize:Int, items:[String], inputText:UITextField, inputTextErr:UILabel) {
        borderColor = inputText.layer.borderColor ?? mmChrome.LIGHT_GREY.cgColor
        self.mItems = items
        self.inputTxt = inputText
        self.inputTxtError = inputTextErr
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SimpleDropDown.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SimpleDropDown.cancleDatePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputText.inputView = self
        inputText.inputAccessoryView = toolBar
        
        
    }
    
    public func selectThis(row: Int) {
        mSelectedItem = row
        selectRow(row, inComponent: 0, animated: true)
    }
    
    @objc func cancleDatePicker(){
        
        self.inputTxt.resignFirstResponder()
    }
    
    @objc func doneDatePicker() {
        
        self.inputTxt.resignFirstResponder()
        
        self.inputTxt.text = getTitle()
        self.inputTxt.layer.borderWidth = 1.0
        self.inputTxt.layer.borderColor = self.borderColor
        self.inputTxtError?.text = ""
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonSetup()
        
        
    }
    
    public func commonSetup() {
        
        self.title = 0
        self.delegate = self
        self.dataSource = self
    }
    
}
