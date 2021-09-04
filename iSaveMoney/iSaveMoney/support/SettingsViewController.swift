//
//  SettingsViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/10/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import TinyConstraints
import ISMLDataService
import ISMLBase
import CheckoutModule

class SettingsViewController: BaseViewController, UIScrollViewDelegate {
    
    static var viewIdentifier:String = "SettingsViewController"
    
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(cancel(_:)))
    }()
    
    lazy var labelCurrency: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("settingsPickCurrencylabel", comment: "Currency"), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        return label
    }()
    lazy var txtCurrency: NiceTextField = {
        let textField = NiceTextField(placeholder: NSLocalizedString("settingsPickCurrency", comment: "Pick a currency"), insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textField.rightView = TxtImageView(image: UIImage(named: "right_chevron"))
        textField.rightViewMode = UITextField.ViewMode.always
        return textField
    }()
    
    lazy var sepLine1: UIView = {
        let uiv = UIView()
        uiv.backgroundColor = UIColor(named: "seperatorColor")
        uiv.height(1)
        
        return uiv
    }()
    
    lazy var labelDateFormat: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("settingsDateFormatlabel", comment: "Date Format"), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))

        return label
    }()
    lazy var txtDateFormat: NiceTextField = {
       let textField = NiceTextField(placeholder: NSLocalizedString("settingsPickDateFormat", comment: "Pick a date format"), insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textField.rightView = TxtImageView(image: UIImage(named: "right_chevron"))
        textField.rightViewMode = UITextField.ViewMode.always
        return textField
   }()
    
    lazy var labelPreviewDate: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("settingsPreview", comment: "Preview"), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        return label
    }()
    
    lazy var sepLine2: UIView = {
        let uiv = UIView()
        uiv.backgroundColor = UIColor(named: "seperatorColor")
        uiv.height(1)
        
        return uiv
    }()
    
    lazy var labelTimeFormat: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("settingsTimeFormatlabel", comment: "Time Format"), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        
        return label
    }()
    lazy var txtTimeFormat: NiceTextField = {
       let textField = NiceTextField(placeholder: NSLocalizedString("settingsPickTimeFormat", comment: "Pick a time format"), insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30))
        textField.rightView = TxtImageView(image: UIImage(named: "right_chevron"))
        textField.rightViewMode = UITextField.ViewMode.always
        return textField
   }()
    
    lazy var txtPreviewTime: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("settingsPreview", comment: "Preview"), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        return label
    }()
    
    lazy var sepLine3: UIView = {
        let uiv = UIView()
        uiv.backgroundColor = UIColor(named: "seperatorColor")
        uiv.height(1)
        
        return uiv
    }()
    
    lazy var selectLanguageSegment: UISegmentedControl = {
        let sctrl = UISegmentedControl(items: [NSLocalizedString("settingLngEng", comment: "English"), NSLocalizedString("settingLngFr", comment: "French")])
        sctrl.selectedSegmentIndex = 0
        sctrl.layer.cornerRadius = 5.0
        return sctrl
    }()
    
    lazy var labelSelectLanguage: NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("settingsSelectLang", comment: "Set Language"), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))

        return label
    }()
    
    lazy var sepLine4: UIView = {
        let uiv = UIView()
        uiv.backgroundColor = UIColor(named: "seperatorColor")
        uiv.height(1)
        
        return uiv
    }()
    
    lazy var btnBackup: UIButton = {
       
        let myButton = UIButton()
        myButton.layer.borderColor = UIColor(named: "normalTextAccentColor")?.cgColor
        myButton.backgroundColor = UIColor(named: "normalTextAccentColor")
        myButton.titleLabel?.font = UIFont(name: IsmFontFamily.DmsansRegular, size: IsmDimems.normal_text_size)
        myButton.tintColor = UIColor.white
        myButton.imageView?.tintColor = UIColor.white
        myButton.layer.borderWidth = 1
        myButton.layer.cornerRadius = 5
        let myImage = UIImage(named: "ic_backup")?.withRenderingMode(.alwaysTemplate)
        myButton.setImage(myImage, for: .normal)
        myButton.setImage(UIImage(named: "ic_backup"), for: .highlighted)
        myButton.imageView?.tintColor = UIColor.white
        myButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        myButton.setTitle(NSLocalizedString("settingsBackup", comment: "Backup and Restore"), for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.setTitleColor(UIColor.white, for: .highlighted)
        myButton.height(42)
        //myButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -myImage!.size.width, bottom: 0, right: 0.0)
        myButton.addTarget(self, action: #selector(backupButton), for: .touchUpInside)
        return myButton
    }()
    
    lazy var sepLine5: UIView = {
        let uiv = UIView()
        uiv.backgroundColor = UIColor(named: "seperatorColor")
        uiv.height(1)
        
        return uiv
    }()
    
    
    lazy var enablePin: UISwitch = {
        let uistch = UISwitch()
        uistch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return uistch
    }()
    
    lazy var enablePinLabel: NormalTextLabel = {
        let label = NormalTextLabel(title: NSLocalizedString("enablePassCode", comment: "enable"))
        return label
    }()
    
    lazy var pinSettingView:UIView = {
        let vw = UIView()
        vw.addSubview(enablePin)
        vw.addSubview(enablePinLabel)
        enablePin.leftToSuperview()
        enablePin.topToSuperview()
        enablePin.bottomToSuperview()
        enablePinLabel.centerYToSuperview()
        enablePinLabel.leadingToTrailing(of: enablePin, offset: 5)
        
        enablePinLabel.rightToSuperview()
        return vw
    }()
    
    lazy var currencyStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [labelCurrency,
                                                txtCurrency,
                                                sepLine1])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 6
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return sv
    }()
    
    lazy var dateFormatStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [labelDateFormat,
                                                txtDateFormat,
                                                labelPreviewDate,
                                                sepLine2])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 6
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return sv
    }()
    
    lazy var timeFormatStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ labelTimeFormat,
                                                 txtTimeFormat,
                                                 txtPreviewTime,
                                                 sepLine3])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 6
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return sv
    }()
    
    lazy var langPickerStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ labelSelectLanguage,
                                                 selectLanguageSegment,
                                                 sepLine4])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 3
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return sv
    }()
    
    lazy var stackViewWrapper: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
                                                        currencyStack,
                                                        dateFormatStack,
                                                        timeFormatStack,
                                                        langPickerStack,
                                                        btnBackup,
                                                        pinSettingView
                                                        ])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(red:0.28, green:0.61, blue:1.00, alpha:1.0)
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        return sv
    }()
    
    
    var contentViewWrapper = UIView()
    //let APPLE_LANGUAGE_KEY = "AppleLanguages"

    
    var appDelegate:AppDelegate!
    var flavor:Flavor!
    var pref:MyPreferences!
    
    var fbUser:FbUser!
    var fbPreferences:FbPreferences!
    var ref: Firestore!
    
    var selectedCurrency = 0
    var selectedTimeFormat = 0
    var selectedDateFormat = 0
    
    var currencyFormatPicker:SimpleDropDown!
    var timeFormatPicker:SimpleDropDown!
    var dateFormatPicker:SimpleDropDown!
    
    var mCurrencies:[String] = []
    var mCurrenciesCodes:[String] = []
    var mTimeFormat:[String] = [
        NSLocalizedString("12-hour clock (e.g [time])", comment: ""),
        NSLocalizedString("24-hour clock (e.g [time])", comment: "")]
    var mTimeFormatCodes:[String] = [
        NSLocalizedString("hh:mm a", comment: ""),
        NSLocalizedString("kk:mm", comment: "")]
    var mDateFormat:[String] = [
        NSLocalizedString("dd/mm/yyyy (e.g [date])", comment: ""),
        NSLocalizedString("dd.mm.yyyy (e.g [date])", comment: ""),
        NSLocalizedString("dd-mm-yyyy (e.g [date])", comment: ""),
        NSLocalizedString("yyyy/mm/dd (e.g [date])", comment: ""),
        NSLocalizedString("yyyy.mm.dd (e.g [date])", comment: ""),
        NSLocalizedString("yyyy-mm-dd (e.g [date])", comment: ""),
        NSLocalizedString("mm/dd/yyyy (e.g [date])", comment: ""),
        NSLocalizedString("mm.dd.yyyy (e.g [date])", comment: ""),
        NSLocalizedString("mm-dd-yyyy (e.g [date])", comment: "")]
    var mDateFormatCodes:[String] = [
        NSLocalizedString("dd/mm/yyyy", comment: ""),
        NSLocalizedString("dd.mm.yyyy", comment: ""),
        NSLocalizedString("dd-mm-yyyy", comment: ""),
        NSLocalizedString("yyyy/mm/dd", comment: ""),
        NSLocalizedString("yyyy.mm.dd", comment: ""),
        NSLocalizedString("yyyy-mm-dd", comment: ""),
        NSLocalizedString("mm/dd/yyyy", comment: ""),
        NSLocalizedString("mm.dd.yyyy", comment: ""),
        NSLocalizedString("mm-dd-yyyy", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyFormatPicker = SimpleDropDown()
        timeFormatPicker = SimpleDropDown()
        dateFormatPicker = SimpleDropDown()
        
        txtCurrency.tag = 0
        txtTimeFormat.tag = 1
        txtDateFormat.tag = 2
        
        self.pref = MyPreferences()
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        self.ref = appDelegate.firestoreRef
        fbUser = FbUser(reference: self.ref)
        fbPreferences = FbPreferences(reference: self.ref)
        
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        
        self.view.addSubview(self.scrollView)
        self.scrollView.edgesToSuperview(usingSafeArea: true)
        
        self.contentViewWrapper.backgroundColor = UIColor(named: "pageBgColor")
        self.scrollView.addSubview(self.contentViewWrapper)
        self.contentViewWrapper.edgesToSuperview()
        self.contentViewWrapper.width(self.scrollView.frameLayoutGuide.layoutFrame.width)
        
        contentViewWrapper.addSubview(self.stackViewWrapper)
        self.stackViewWrapper.edgesToSuperview(insets: .left(15) + .top(10) + .right(15) + .bottom(50))
        
        self.title = NSLocalizedString("toolsAndSettingTitle", comment: "Tools & Settings")
        
        
        
        let date = Date()
        var index:Int = 0
        for timeCode in mTimeFormatCodes {
            
            
            mTimeFormat[index] = mTimeFormat[index].replacingOccurrences(of: "[time]", with: UtilsIsm.dateFormatOrTimeFor(date, format: timeCode))
            
            if timeCode == self.pref.getTimeFormat() {
                self.selectedTimeFormat = index
                self.txtTimeFormat.text = mTimeFormat[index]
            }
            
            index = index + 1
        }
        
        index = 0
        for dateCode in mDateFormatCodes {
            
            
            mDateFormat[index] = mDateFormat[index].replacingOccurrences(of: "[date]", with: UtilsIsm.dateFormatOrTimeFor(date, format: dateCode))
            
            if dateCode.replacingOccurrences(of: "m", with: "M") == self.pref.getDateFormat() {
                self.selectedDateFormat = index
                self.txtDateFormat.text =  mDateFormat[index]
            }
            
            index = index + 1
        }
        
        
        let currencies:[MCurrency] = IsmUtils.readCurrenciesFile()
        
        let currentLocale = NSLocale.current
        
        
        var countryCode = (currentLocale.regionCode ?? NSLocalizedString("SettingsnoCurrencyCode", comment: "no currency code"))
        
        if self.pref.getCurrency() != "" {
            
            countryCode = self.pref.getCurrency()
        }
        
        index = 0
        for currency in currencies {
            
            
            if currency.local.contains(countryCode) {
                
                self.selectedCurrency = index
                self.txtCurrency.text = currency.name
                
                print("SelectedCurrency: \(currency.local)")
            }
            mCurrenciesCodes.append(currency.local)
            mCurrencies.append(currency.name)
            
            
            
            index = index + 1
        }
        //pickers
        self.currencyFormatPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: mCurrencies, inputText: self.txtCurrency, inputTextErr: UILabel())
        self.currencyFormatPicker.selectThis(row: self.selectedCurrency)
        
        
        self.timeFormatPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: mTimeFormat, inputText: self.txtTimeFormat, inputTextErr: UILabel())
        self.timeFormatPicker.selectThis(row: self.selectedTimeFormat)

        self.dateFormatPicker.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, items: mDateFormat, inputText: self.txtDateFormat, inputTextErr: UILabel())
        self.dateFormatPicker.selectThis(row: self.selectedDateFormat)
        
        
        self.txtCurrency.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        self.txtTimeFormat.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        self.txtDateFormat.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        self.selectLanguageSegment.setTitle(NSLocalizedString("txtSelectEn", comment: "en"), forSegmentAt: 0)
        self.selectLanguageSegment.setTitle(NSLocalizedString("txtSelectFr", comment: "fr"), forSegmentAt: 1)
        self.selectLanguageSegment.addTarget(self, action: #selector(SettingsViewController.languageSwitcher(_:)), for: .valueChanged)
        
        self.labelSelectLanguage.text = NSLocalizedString("txtSelectTheLanguage", comment: "Select lang")
        
        if pref.getSelectedLanguage() == "fr" {
            self.selectLanguageSegment.selectedSegmentIndex = 1
        }else {
            self.selectLanguageSegment.selectedSegmentIndex = 0
        }
        
        if (flavor.getFlavor() != FlavorType.legacy){
            self.labelSelectLanguage.isHidden = true
            self.selectLanguageSegment.isHidden = true
        }
        
        print("PIN Code: \(self.pref.getUnlockCode())")
        if self.pref.getUnlockCode() != "" {
            enablePin.isOn = true
        }
    }
    
    
    @objc func languageSwitcher(_ sender:UISegmentedControl!) {
        
        do {
            print("languageSelection index selected.. ")
            
            if self.selectLanguageSegment.selectedSegmentIndex == 0 {
                AppLanguage.setAppleLAnguageTo(lang: "en")
                pref.setSelectedLanguage(lang: "en")
                self.fbPreferences.savePref(user_gid: pref.getUserIdentifier(), key: "selectedLanguage", value: "en")
            } else {
                
                AppLanguage.setAppleLAnguageTo(lang: "fr")
                pref.setSelectedLanguage(lang: "fr")
                self.fbPreferences.savePref(user_gid: pref.getUserIdentifier(), key: "selectedLanguage", value: "fr")
            }
        } catch {
            print("Unexpected error: \(error).")
        }
        
        
        self.askRefreshScreen()
        
        
    }
    
    func askRefreshScreen () {
        
        let alertController = UIAlertController(title: NSLocalizedString("alterLanguageChanged", comment: "Lang changed"),
                                                message: NSLocalizedString("alterLanguageChangedBody", comment: "Lang changed body..."), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("text_ok", comment: "ok"), style: .default) { action in
            // perhaps use action.title here
            
        })
        
        
        self.present(alertController, animated: true) {}
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch  textField.tag {
            
        case 0://currency
            
            print(mCurrenciesCodes[currencyFormatPicker.getId()])
            self.pref.setCurrency(mCurrenciesCodes[currencyFormatPicker.getId()])
            self.fbPreferences.savePref(user_gid: pref.getUserIdentifier(), key: "currency", value: pref.getCurrency())
            break
            
        case 1://time format
            
            let date = Date()
            
            self.pref.setTimeFormat(mTimeFormatCodes[timeFormatPicker.getId()])
            txtPreviewTime.text = "\(NSLocalizedString("SettingsPreviewCode", comment: "Preview:")) \(UtilsIsm.dateFormatOrTimeFor(date, format: mTimeFormatCodes[timeFormatPicker.getId()]))"
            
            self.fbPreferences.savePref(user_gid: pref.getUserIdentifier(), key: "timeFormat", value: pref.getTimeFormat())
            break
            
        case 2://date format
            let date = Date()
            
            self.pref.setDateFormat(mDateFormatCodes[dateFormatPicker.getId()])
            labelPreviewDate.text = "\(NSLocalizedString("SettingsPreviewCode", comment: "Preview:")) \(UtilsIsm.dateFormatOrTimeFor(date, format: mDateFormatCodes[dateFormatPicker.getId()]))"
            
            self.fbPreferences.savePref(user_gid: pref.getUserIdentifier(),
                                        key: "dateFormat",
                                        value: pref.getDateFormat())
            break
        default:
            
            break
            
        }
        
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
         
         appDelegate.navigateTo(instance: ViewController())
     }
    
    @objc func backupButton(sender: UIButton!){
        let pref = AccessPref()
        if !pref.isProAccount() {
           IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("fullBackupTitle", comment: "Backup and Restore") )
            //self.present(confirm, animated: true) {}
        }else{
            let backupCv = BackupRestoreViewController()
            backupCv.params = params
            self.navigationController?.pushViewController(backupCv, animated: true)
            //appDelegate.navigateTo(instance: BackupRestoreViewController(), params: params)
        }
        
        
    }
    
    @objc func switchValueDidChange(){
        print(self.pref.getUnlockCode())
        if enablePin.isOn {
            self.navigationController?.pushViewController(SetPINViewController(), animated: true)
        } else{
            self.pref.setUnlockCode("")
        }
        
    }
    
}
