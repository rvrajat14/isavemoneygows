//
//  BoxPicker.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/22/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public class BoxPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var inputTxt:UITextField!
    var inputTxtError:UILabel!
    var mItems:[PickerItem] = []
    var mSelectedItem:Int = -1
    let toolBar = UIToolbar()

    
    // Mark: UIPicker Delegate / Data Source
    
    func setSelected(index:Int) {
        
        mSelectedItem = index
    
        self.selectRow(index, inComponent: 0, animated: true)
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
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        
        self.backgroundColor = UIColor(red: 34.0/255.0, green: 167.0/255.0, blue: 239.0/255.0, alpha: 0)
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(BoxPicker.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(BoxPicker.cancleDatePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.commonSetup()
        
        
    }
    
    @objc func cancleDatePicker(){

        self.inputTxt.resignFirstResponder()
    }

    @objc func doneDatePicker() {
        
        self.inputTxt.resignFirstResponder()
        
        self.inputTxt.text = getTitle()
        self.inputTxt.layer.borderWidth = 0.0
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
