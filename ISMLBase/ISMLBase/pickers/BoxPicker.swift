//
//  BoxPicker.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/22/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public protocol BoxPickDelegate: class {
    func onItemSeleted(value: PickerItem)
    func onClearSeleted()
}

public class BoxPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var inputTxt:UITextField!
    var inputTxtError:UILabel!
    var borderColor:CGColor!
    var mItems:[PickerItem] = []
    var mSelectedItem:Int = -1
    public let toolBar = UIToolbar()
    public var delegateSet: BoxPickDelegate!
    

    
    // Mark: UIPicker Delegate / Data Source
    
    public func setSelected(index:Int) {
        
        if index > -1 {
            mSelectedItem = index
            self.selectRow(index, inComponent: 0, animated: true)
        }
        
    }
    
    var title:Int = 0 {
        didSet {
            
            selectRow(title, inComponent: 0, animated: true)
        }
    }
    
    var onTitleSelected: ((_ title: Int) -> Void)?
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return mItems[row].title
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
      
        return mItems.count
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        mSelectedItem = row
    }
    
    public func getId() -> Int {
        
        if self.mSelectedItem != -1 && mItems.count > 0 {
            
            return mItems[mSelectedItem].id
        } else {
            return -1
        }
    }
    
    public func getGid() -> String {
        
        if self.mSelectedItem != -1 && mItems.count > 0 {
            
            return mItems[mSelectedItem].gid
        } else {
            
            return ""
        }
    }
    
    public func getTitle() -> String {
        
        if self.mSelectedItem != -1 && mItems.count > 0 {
            
            return mItems[mSelectedItem].title
        } else {
            
            return ""
        }
    }
    
    
    public func setUp(widthSize:Int, heightSize:Int, items:[PickerItem], inputText:UITextField, inputTextErr:UILabel) {
        
        self.mItems = items
        self.inputTxt = inputText
        self.inputTxtError = inputTextErr
        borderColor = inputText.layer.borderColor
        
        self.inputTxt.inputView = self
        self.inputTxt.inputAccessoryView = self.toolBar
        
        
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let clearButton = UIBarButtonItem(title: NSLocalizedString("text_clear", comment: "Clear"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(clearPicker))
        let space1Button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancleDatePicker))
        
        toolBar.setItems([cancelButton, spaceButton, clearButton, space1Button, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.commonSetup()
        
        
    }
    
    @objc func cancleDatePicker(){

        self.inputTxt.resignFirstResponder()
    }

    @objc func doneDatePicker() {
        if mSelectedItem < 0 {
            self.setSelected(index: 0)
        }
        self.inputTxt.resignFirstResponder()
        
        self.inputTxt.text = getTitle()
        self.inputTxt.layer.borderColor = borderColor
        self.inputTxtError?.text = ""
        
        
        
        if self.delegateSet != nil  && mSelectedItem > -1 {
            self.delegateSet.onItemSeleted(value: mItems[mSelectedItem])
        }
        
    }
    
    @objc func clearPicker() {
        self.inputTxt.resignFirstResponder()
        
        self.inputTxt.text = ""
        self.inputTxt.layer.borderColor = borderColor
        self.inputTxtError?.text = ""
        mSelectedItem = -1
        self.selectRow(-1, inComponent: 0, animated: false)
        
        if self.delegateSet != nil {
            self.delegateSet.onClearSeleted()
        }
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
