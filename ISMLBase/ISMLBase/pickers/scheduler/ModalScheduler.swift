
//
//  ModalScheduler.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 9/24/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import UIKit


// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method

public protocol ModalSchedulerDelegate: class {
    func scheduleSelected(schedule: ScheduleModel)
}

public class ModalScheduler: UIViewController, DateDelegate, TimeDelegate {
    
    public func timeSelected(tag: Int, cancel: Bool) {
        switch tag {
        case 0:
            if !cancel {
                self.dateSelector.setCurrentDate(currentDate: timeSelector.date)
                self.textStartTime.text = UtilsIsm.timeFormat(Int(timeSelector.date.timeIntervalSince1970), tformat: timeFormat)
            }
            self.textStartTime.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    public func dateSelected(tag: Int, cancel: Bool) {
        switch tag {
        case 0:
            if !cancel {
                self.timeSelector.setCurrentDate(currentDate: dateSelector.date)
                self.textStartDate.text = UtilsIsm.formatTimeStamp(Int(dateSelector.date.timeIntervalSince1970), tformat: dateFormt)
            }
            self.textStartDate.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    let toolBar = UIToolbar()
    
    var textFirstGoesOff:UILabel!
    var labelStartDate: UILabel!
    var textStartDate: UITextField!
    var startDateView: UIStackView!
    var labelStartTime: UILabel!
    var textStartTime: UITextField!
    var startTimeStackView: UIStackView!
    var startTimeDateStack: UIStackView!
    
    
    var titleLabel:UILabel!
    var repeatLabel:UILabel!
    var repeatValue:UILabel!
    var repeatStepper:UIStepper!
    var stackRepeat:UIStackView!
    var stackPickerContent:UIStackView!
    var scheduleType:UISegmentedControl!
    var scheduleLimit:UISegmentedControl!
    
    //
    var numberRepeatValue:UILabel!
    var numberRepeatStepper:UIStepper!
    var numberRepeatStack:UIStackView!
    
    public var flavor:Flavor!
    public var dateFormt:String!
    public var timeFormat:String!
    
    
    public var schedule:ScheduleModel = ScheduleModel()
    
    var dateSelector:CalendarPicker!
    var timeSelector:TimePicker!
    
    // This variable will be set as the view controller so that
    // the keyboard can send messages to the view controller.
    public weak var delegate: ModalSchedulerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
        
//        self.navigationController!.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        self.navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = UIColor.white
        } else {
            self.view.backgroundColor = UIColor.black
        }
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(ModalScheduler.cancelButtonAction))
        let applyButton = UIBarButtonItem(title: NSLocalizedString("text_save", comment: "Save"), style: .plain, target: self, action: #selector(ModalScheduler.applyButtonAction))
        
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem = applyButton
        
        self.title = NSLocalizedString("MSTitle", comment: "Screen title")
        
        
        
        dateSelector = CalendarPicker()
        dateSelector.tag = 0
        dateSelector.delegate = self
        //dateSelector.setMinDate(date: (Date()+86400))
        dateSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, selectedDate: Date(timeIntervalSince1970: Double(schedule.nextOccurred)),displayToday: false, dformat: dateFormt)
        
        
        timeSelector = TimePicker()
        timeSelector.tag = 0
        timeSelector.delegate = self
        timeSelector.setUp(widthSize: Int(self.view.frame.width), heightSize: 220, selectedDate: Date(timeIntervalSince1970: Double(schedule.nextOccurred)),displayNow: false, format: timeFormat)
        
        
        setUp()
       
    }
    @objc func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func applyButtonAction() {
        self.saveScheduler()
        delegate?.scheduleSelected(schedule: schedule)
        dismiss(animated: true, completion: nil)
    }
    
    public func setUp() {
        
        
        repeatStepper = {
            
            let stepper = UIStepper(frame: CGRect(x: 10, y: 150, width: 0, height: 0))
            stepper.wraps = true
            stepper.autorepeat = true
            stepper.maximumValue = 50
            stepper.minimumValue = 1
            stepper.tintColor = Const.BLUE
            return stepper
        }()
        
        repeatLabel = {
            
            let label = UILabel()
            label.text = NSLocalizedString("spRepeatEvery", comment: "Repeat every")
            label.font = UIFont.systemFont(ofSize: 13)
            label.textAlignment = .left
            return label
        }()
        
        repeatValue = {
            
            let label = UILabel()
            label.text = "1"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            return label
        }()
        
        titleLabel = {
            let title = UILabel()
            title.text = NSLocalizedString("MSThenFollosAs", comment: "Then follow as:")
            title.font = UIFont.systemFont(ofSize: 13)
            title.textAlignment = .left
            
            return title
        }()
        
        stackRepeat = {
            let s = UIStackView(arrangedSubviews: [repeatLabel, repeatValue, repeatStepper])
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.axis = .horizontal
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        scheduleType = {
            let segemented = UISegmentedControl (items: [
                NSLocalizedString("spDay", comment: "Day"),
                NSLocalizedString("spWeek", comment: "Week"),
                NSLocalizedString("spMonth", comment: "Month"),
                NSLocalizedString("spYear", comment: "Year")])
            segemented.frame = CGRect()
            segemented.selectedSegmentIndex = 2
            segemented.tintColor = Const.BLUE
            return segemented
        }()
        
        scheduleLimit = {
            let segemented = UISegmentedControl (items: [
                NSLocalizedString("spForever", comment: "Pour toujours"),
                NSLocalizedString("spForNumberTime", comment: "Nombre de fois")])
            segemented.frame = CGRect()
            segemented.selectedSegmentIndex = 0
            segemented.tintColor = Const.BLUE
            return segemented
        }()
        
        //number of repeat
        numberRepeatValue = {
            let textView = UILabel()
            textView.text = "2"
            //label.center = CGPoint(x: 160, y: 285)
            textView.textAlignment = .center
            textView.font = UIFont.boldSystemFont(ofSize: 16)
            return textView
        }()
        numberRepeatStepper = {
            let stepper = UIStepper(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            stepper.wraps = true
            stepper.autorepeat = true
            stepper.maximumValue = 50
            stepper.minimumValue = 1
            stepper.stepValue = 2
            stepper.tintColor = Const.BLUE
            return stepper
        }()
        numberRepeatStack = {
            let s = UIStackView(arrangedSubviews: [numberRepeatValue, numberRepeatStepper])
            s.axis = .horizontal
            s.distribution = .fill
            //s.alignment = .firstBaseline
            s.spacing = 6
            s.isHidden = true
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        ///top
        textFirstGoesOff = {
            let title = UILabel()
            title.text = NSLocalizedString("MSFirstGoesOffOn", comment: "First goes off on")
            title.font = UIFont.systemFont(ofSize: 13)
            title.textAlignment = .left
            
            return title
        }()
        labelStartDate = {
            let title = UILabel()
            title.text = NSLocalizedString("MSDate", comment: "Date:")
            title.font = UIFont.systemFont(ofSize: 13)
            title.textAlignment = .left
            
            return title
        }()
        textStartDate = {
            
            let textfield = UITextField(frame: CGRect(x: 20.0, y: 90.0, width: 100.0, height: 100.0))
            self.automaticallyAdjustsScrollViewInsets = false
            textfield.textAlignment = .left
            textfield.font = UIFont.systemFont(ofSize: 15)
            textfield.borderStyle = UITextField.BorderStyle.roundedRect
            textfield.autocorrectionType = UITextAutocorrectionType.no
            textfield.keyboardType = UIKeyboardType.default
            textfield.returnKeyType = UIReturnKeyType.done
            textfield.keyboardType = .default
            
            textfield.inputView = dateSelector
            textfield.inputAccessoryView = dateSelector.toolBar
            textfield.text = UtilsIsm.formatTimeStamp(Int(schedule.nextOccurred), tformat: dateFormt)
            
            return textfield
        }()
        startDateView = {
            let s = UIStackView(arrangedSubviews: [labelStartDate, textStartDate])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.translatesAutoresizingMaskIntoConstraints = false
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            s.translatesAutoresizingMaskIntoConstraints = false
            
            return s
        }()
        labelStartTime = {
            let title = UILabel()
            title.text = NSLocalizedString("MSTime", comment: "Time")
            title.font = UIFont.systemFont(ofSize: 13)
            title.textAlignment = .left
            
            return title
        }()
        textStartTime = {
            
            let textfield = UITextField(frame: CGRect(x: 20.0, y: 90.0, width: 100.0, height: 100.0))
            self.automaticallyAdjustsScrollViewInsets = false
            textfield.textAlignment = .left
            textfield.font = UIFont.systemFont(ofSize: 15)
            textfield.borderStyle = UITextField.BorderStyle.roundedRect
            textfield.autocorrectionType = UITextAutocorrectionType.no
            textfield.keyboardType = UIKeyboardType.default
            textfield.returnKeyType = UIReturnKeyType.done
            textfield.keyboardType = .default
            
            textfield.inputView = timeSelector
            textfield.inputAccessoryView = timeSelector.toolBar
            textfield.text = UtilsIsm.timeFormat(Int(schedule.nextOccurred), tformat: timeFormat)
            
            return textfield
        }()
        startTimeStackView = {
            let s = UIStackView(arrangedSubviews: [labelStartTime, textStartTime])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.translatesAutoresizingMaskIntoConstraints = false
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            s.translatesAutoresizingMaskIntoConstraints = false
            return s
        }()
        startTimeDateStack = {
            let s = UIStackView(arrangedSubviews: [startDateView, startTimeStackView])
            s.axis = .horizontal
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            s.translatesAutoresizingMaskIntoConstraints = false
            return s
        }()
        
        
        startDateView.leadingAnchor.constraint(equalTo: startTimeDateStack.leadingAnchor).isActive = true
        startTimeStackView.trailingAnchor.constraint(equalTo: startTimeDateStack.trailingAnchor).isActive = true
        startTimeStackView.leadingAnchor.constraint(equalTo: startDateView.trailingAnchor, constant: 6).isActive = true
        startTimeStackView.widthAnchor.constraint(equalTo:startDateView.widthAnchor).isActive = true
        
        stackPickerContent = {
            let s = UIStackView(arrangedSubviews: [textFirstGoesOff,
                                                   startTimeDateStack,
                                                   titleLabel,
                                                   stackRepeat,
                                                   scheduleType,
                                                   scheduleLimit,
                                                   numberRepeatStack])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 12
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        
        self.view.addSubview(stackPickerContent)
    
        
        
        //stack step count constraint
        stackRepeat.translatesAutoresizingMaskIntoConstraints = false
        stackRepeat.leadingAnchor.constraint(equalTo: stackPickerContent.leadingAnchor).isActive = true
        stackRepeat.trailingAnchor.constraint(equalTo: stackPickerContent.trailingAnchor).isActive = true
        //stackRepeat.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        //stepper constraint
        repeatStepper.translatesAutoresizingMaskIntoConstraints = false
        repeatStepper.trailingAnchor.constraint(equalTo: stackRepeat.trailingAnchor).isActive = true
        repeatStepper.addTarget(self, action: #selector(ModalScheduler.stepChanged(_:)), for: .valueChanged)
        
        
        //stepper number repeat
        numberRepeatStepper.addTarget(self, action: #selector(ModalScheduler.stepNumberChanged(_:)), for: .valueChanged)
        numberRepeatValue.translatesAutoresizingMaskIntoConstraints = false
        numberRepeatValue.leadingAnchor.constraint(equalTo: numberRepeatStack.leadingAnchor)
        numberRepeatValue.trailingAnchor.constraint(equalTo: numberRepeatStepper.leadingAnchor)
        numberRepeatValue.widthAnchor.constraint(equalToConstant: 140)
        
        //picker title constraint
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: stackPickerContent.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: stackPickerContent.trailingAnchor).isActive = true
        
        //picker step type
        scheduleType.translatesAutoresizingMaskIntoConstraints = false
        scheduleType.leadingAnchor.constraint(equalTo: stackPickerContent.leadingAnchor).isActive = true
        scheduleType.trailingAnchor.constraint(equalTo: stackPickerContent.trailingAnchor).isActive = true
        
        //pick stack content constraint
        stackPickerContent.translatesAutoresizingMaskIntoConstraints = false
        stackPickerContent.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        stackPickerContent.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        stackPickerContent.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        
        //Type schedule
        scheduleType.addTarget(self, action: #selector(ModalScheduler.typeChanged(_:)), for: .valueChanged)
        //Type schedule limit
        scheduleLimit.addTarget(self, action: #selector(ModalScheduler.limitTypeChanged(_:)), for: .valueChanged)
        

        
        updateViews()
        
        
    }
    

    public func updateSchedule(schedule:ScheduleModel) {
        
        self.schedule = schedule
        //updateViews()
    }
    
    public func getSchedule() -> ScheduleModel {
        return schedule
    }
    
    @objc func stepChanged(_ sender:UIStepper!) {
        
        repeatValue.text = String(Int(sender.value))
        schedule.step = Int(sender.value)
    }
    
    @objc func typeChanged(_ sender:UISegmentedControl!) {
        schedule.type = sender.selectedSegmentIndex
    }
    
    @objc func limitTypeChanged(_ sender:UISegmentedControl!) {
        
        
        if sender.selectedSegmentIndex == 1 {
            self.numberRepeatStack.isHidden = false
        } else {
            self.numberRepeatStack.isHidden = true
            
        }
        
      
    }
    @objc func stepNumberChanged(_ sender:UIStepper!) {
        
        self.numberRepeatValue.text = String(Int(sender.value))
        
        schedule.numberEvent = Int(sender.value)
        
    }
    
    public func cancelScheduler() {
        
        //self.delegate?.keyWasTapped(character: "Test")
        self.delegate?.scheduleSelected(schedule: ScheduleModel())
    }
    
    
    public func saveScheduler() {
        
        schedule.type = scheduleType.selectedSegmentIndex
        
        
        if scheduleLimit.selectedSegmentIndex == SchedulCnt.FOR_EVER {
            schedule.numberEvent = 0
            schedule.typeMaxOccur = SchedulCnt.FOR_EVER
      
        } else {
            
            schedule.typeMaxOccur = SchedulCnt.NUMBER_EVENT
        
            
        }
        
        schedule.setNextOccur(firstGoesOff: Int(dateSelector.date.timeIntervalSince1970))
        schedule.setLastOccurred(schedule.nextOccurred)
        
        
        self.delegate?.scheduleSelected(schedule: schedule)
    }
    
    public func updateViews() {
        
        self.textStartDate.text = UtilsIsm.formatTimeStamp(Int(dateSelector.date.timeIntervalSince1970), tformat: dateFormt)
        self.textStartTime.text = UtilsIsm.timeFormat(Int(timeSelector.date.timeIntervalSince1970), tformat: timeFormat)
        
        repeatValue.text = "\(schedule.step!)"
        repeatStepper.value = Double(schedule.step)
        scheduleType.selectedSegmentIndex = schedule.type
        
         
        if schedule.typeMaxOccur != SchedulCnt.FOR_EVER {
            
            numberRepeatValue.text = "\(schedule.numberEvent!)"
            numberRepeatStepper.value = Double(schedule.numberEvent)
            numberRepeatStack.isHidden = false
            scheduleLimit.selectedSegmentIndex = 1
        } else {
            numberRepeatStack.isHidden = true
            scheduleLimit.selectedSegmentIndex = SchedulCnt.FOR_EVER
        }
        
    }
}
