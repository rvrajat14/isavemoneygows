//
//  SchedulePicker.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/3/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

//import Foundation
//SchedulePicker.swif
import UIKit

// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method
public protocol SchedulerDelegate: class {
    func keyWasTapped(character: String)
}


public class SchedulePicker: UIView {
    
    let toolBar = UIToolbar()
    
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
    
    var schedule:ScheduleModel = ScheduleModel()
   
    // This variable will be set as the view controller so that
    // the keyboard can send messages to the view controller.
    weak var delegate: SchedulerDelegate?
    
    // MARK:- keyboard initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        /*let xibFileName = "SchedulePicker" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds*/
        
        
    }
    
    func setUp(widthSize:Int, heightSize:Int, schedul:ScheduleModel) {
       
        
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
            label.textAlignment = .left
            return label
        }()
        
        repeatValue = {
            
            let label = UILabel()
            label.text = "1"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 17)
            return label
        }()
        
        titleLabel = {
            let title = UILabel()
            title.text = NSLocalizedString("spScheduleTo", comment: "Schedule to...")
            title.font = UIFont.boldSystemFont(ofSize: 16)
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
            textView.font = UIFont.boldSystemFont(ofSize: 17)
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
        
        stackPickerContent = {
            let s = UIStackView(arrangedSubviews: [titleLabel, stackRepeat,scheduleType,scheduleLimit,numberRepeatStack])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 12
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        self.frame = CGRect(x: 10, y: 50, width: widthSize, height: heightSize)
        //self.backgroundColor = UIColor.white
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("text_done", comment: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SchedulePicker.saveScheduler))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("text_cancel", comment: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SchedulePicker.cancelScheduler))
        
        toolBar.setItems([cancelButton, spaceButton, spaceButton1, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.addSubview(toolBar)
        self.addSubview(stackPickerContent)
        
        //self.addSubview(stackRepeat)
        
        
        //stack step count constraint
        stackRepeat.translatesAutoresizingMaskIntoConstraints = false
        stackRepeat.leadingAnchor.constraint(equalTo: stackPickerContent.leadingAnchor).isActive = true
        stackRepeat.trailingAnchor.constraint(equalTo: stackPickerContent.trailingAnchor).isActive = true
        //stackRepeat.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        //stepper constraint
        repeatStepper.translatesAutoresizingMaskIntoConstraints = false
        repeatStepper.trailingAnchor.constraint(equalTo: stackRepeat.trailingAnchor).isActive = true
        repeatStepper.addTarget(self, action: #selector(SchedulePicker.stepChanged(_:)), for: .valueChanged)
        
        
        //stepper number repeat
        numberRepeatStepper.addTarget(self, action: #selector(SchedulePicker.stepNumberChanged(_:)), for: .valueChanged)
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
        stackPickerContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stackPickerContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        stackPickerContent.topAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        
        //Type schedule limit
        scheduleLimit.addTarget(self, action: #selector(SchedulePicker.limitTypeChanged(_:)), for: .valueChanged)
        
      
        self.schedule.type = SchedulTyp.MONTHLY
        self.schedule.step = 1
        self.schedule.weeklyDay = -1
        self.schedule.monthlyOption = -1
        self.schedule.numberEvent = 0
        self.schedule.dateLimitOccur = 0
        self.schedule.typeMaxOccur = SchedulCnt.FOR_EVER
        self.schedule.setNextOccur(firstGoesOff: Int(Date().timeIntervalSince1970))
        self.schedule.setLastOccurred(schedule.nextOccurred)
        //
        self.schedule = schedul
        updateViews()
        //number of repetition
        
        
    }
    
    func updateSchedule(schedule:ScheduleModel) {
        
        self.schedule = schedule
        updateViews()
    }
    
    func getSchedule() -> ScheduleModel {
        return schedule
    }

    @objc func stepChanged(_ sender:UIStepper!) {
        print("UIStepper is now \(Int(sender.value))")
        repeatValue.text = String(Int(sender.value))
        schedule.step = Int(sender.value)
   }
    
    @objc func limitTypeChanged(_ sender:UISegmentedControl!) {
        
        print("Index linit.. \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 1 {
            self.numberRepeatStack.isHidden = false
        } else {
            self.numberRepeatStack.isHidden = true
            
        }
        
        print("Segment is now \(Int(sender.selectedSegmentIndex))")
    }
    @objc func stepNumberChanged(_ sender:UIStepper!) {
        
        self.numberRepeatValue.text = String(Int(sender.value))
    
        schedule.numberEvent = Int(sender.value)
        
        print("UIStepper is now \(Int(sender.value))")
    }
    
    @objc func cancelScheduler() {
        
        //self.delegate?.keyWasTapped(character: "Test")
    self.delegate?.keyWasTapped(character: "")
    }
    
  
    @objc func saveScheduler() {
        
        schedule.type = scheduleType.selectedSegmentIndex
        
        
        if scheduleLimit.selectedSegmentIndex == SchedulCnt.FOR_EVER {
            schedule.numberEvent = 0
            schedule.typeMaxOccur = SchedulCnt.FOR_EVER
        } else {
            
            schedule.typeMaxOccur = SchedulCnt.NUMBER_EVENT
            
        }
        
        schedule.setNextOccur(firstGoesOff: Int(Date().timeIntervalSince1970))
        schedule.setLastOccurred(schedule.nextOccurred)
        
        self.delegate?.keyWasTapped(character: self.schedule.verboseSchedule())
    }
    
    func updateViews() {
        
        repeatValue.text = "\(schedule.step!)"
        repeatStepper.value = Double(schedule.step)
        scheduleType.selectedSegmentIndex = schedule.type
        
        
        print("Index linit \(schedule.typeMaxOccur)")
        
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

