//
//  CalculatorModal.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/11/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}

public protocol CalculatorDelegate: class {
    func valueReturn(value: String)
}



public class CalculatorModalDel: UIViewController {
    
    
    var pref: MyPreferences!
    var flavor:Flavor!
    public weak var delegate:CalculatorDelegate?
    
    var firstValue = true
    var subTotal: Double?
    var lastOperator: operatorType?
    var initialValue = 0.0
    var no_calc = true
    var sum = ""
    var calc = ""
    var result:Float = 0
    var result_mul:Float = 1
    var result_div:Float = 1
    var press:String = ""
    var cursor:Int = 0

    
    
    enum operatorType {
        case plus
        case subtract
        case multiply
        case divide
    }
   
    
    var txtCalDisplay:UITextView = {
        
        let label = UITextView()
        label.text = "0.0"
        label.font = UIFont.systemFont(ofSize: 24)
        label.backgroundColor = Const.GREY_CLEAR
        label.height(50)
        label.textAlignment = NSTextAlignment.right
        
        return label
    }()
    
    lazy var cleanBtn:CalButton = {
        
        let button = CalButton(title: "CE")
        button.payload = "EC"
        button.backgroundColor = Const.greyDarkColor
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var cleanAllBtn:CalButton = {
        
        let button = CalButton(title: "CA")
        button.payload = "EC_ALL"
        button.backgroundColor = Const.RED
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func clenTapped(event:CalButton) {
       
        if(firstValue) {
            txtCalDisplay.text = ""
        }
        
        if event.payload == "EC" {
            
            if firstValue {
                 return
            }
            
            let fromDisplay:String = String(txtCalDisplay.text!)
            let lastIndex = fromDisplay.count - 1
            txtCalDisplay.text = String(fromDisplay.prefix(lastIndex))
        
            if(txtCalDisplay.text.count <= 0) {
                firstValue = true
            }
            
            return
        }
        
        if event.payload == "EC_ALL" {
            txtCalDisplay.text = "0.0"
            firstValue = true
            return
        }
        
        
        processButtonPress(val: event.payload!)
    }
    
    lazy var row0:UIStackView = {
        let s = UIStackView(arrangedSubviews: [cleanAllBtn, cleanBtn])
        s.spacing = 10
        s.axis = .horizontal
        s.distribution = UIStackView.Distribution.equalSpacing
        return s
    }()
    
    
    lazy var number7Btn:CalButton = {
        let button = CalButton(title: "7")
        
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var number8Btn:CalButton = {
        let button = CalButton(title: "8")
        
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var number9Btn:CalButton = {
        let button = CalButton(title: "9")
        
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var numberPlusBtn:CalButton = {
        let button = CalButton(title: "+")
        
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var row1:UIStackView = {
        let s = UIStackView(arrangedSubviews: [number7Btn,
                                               number8Btn,
                                               number9Btn,
                                               numberPlusBtn])
        s.spacing = 10
        s.axis = .horizontal
        return s
    }()
    
    
    lazy var number4Btn:CalButton = {
        let button = CalButton(title: "4")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var number5Btn:CalButton = {
        let button = CalButton(title: "5")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var number6Btn:CalButton = {
        let button = CalButton(title: "6")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var numberMinusBtn:CalButton = {
        let button = CalButton(title: "-")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var row2:UIStackView = {
        let s = UIStackView(arrangedSubviews: [number4Btn,
                                               number5Btn,
                                               number6Btn,
                                               numberMinusBtn])
        s.spacing = 10
        s.axis = .horizontal
        return s
    }()
    
    
    lazy var number1Btn:CalButton = {
        let button = CalButton(title: "1")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var number2Btn:CalButton = {
        let button = CalButton(title: "2")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var number3Btn:CalButton = {
        let button = CalButton(title: "3")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var numberMulBtn:CalButton = {
        let button = CalButton(title: "*")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var row3:UIStackView = {
        let s = UIStackView(arrangedSubviews: [number1Btn,
                                               number2Btn,
                                               number3Btn,
                                               numberMulBtn])
        s.spacing = 10
        s.axis = .horizontal
        return s
    }()
    
    
    
    
    lazy var numberDotBtn:CalButton = {
        let button = CalButton(title: ".")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var numberZeroBtn:CalButton = {
        let button = CalButton(title: "0")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var numberEqualBtn:CalButton = {
        let button = CalButton(title: "=")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    lazy var numberDivBtn:CalButton = {
        let button = CalButton(title: "÷")
        button.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var row4:UIStackView = {
        let s = UIStackView(arrangedSubviews: [numberDotBtn,
                                               numberZeroBtn,
                                               numberEqualBtn,
                                               numberDivBtn])
        s.spacing = 10
        s.axis = .horizontal
        return s
    }()
    
    
    lazy var wrapper:UIStackView = {
        let s = UIStackView(arrangedSubviews: [txtCalDisplay,
                                               row0,
                                               row1,
                                               row2,
                                               row3,
                                               row4])
        s.spacing = 10
        s.axis = .vertical
        return s
    }()
    
    lazy var cancelButton:UIBarButtonItem = {
        
        var nemu = UIBarButtonItem(image: UIImage(named: "back_icon"),
                                   landscapeImagePhone: UIImage(named: "back_icon"),
                                   style: .plain, target: self,
                                   action: #selector(cancel(_:)))
        return nemu
    }()
    
    
    lazy var editButton:UIBarButtonItem = {
        var nemu = UIBarButtonItem(title: NSLocalizedString("text_apply",
                                   comment: "Apply"),
                                   style: .done,
                                   target: self,
                                   action:  #selector(edit(_:)))
        return nemu
    }()
    
    

    
     public override func viewDidLoad() {
           super.viewDidLoad()
        
        flavor = Flavor()
        
        self.pref = MyPreferences()
        
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.isHidden = true
        
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        self.view.backgroundColor = UIColor(named: "pageBgColor")
        
        self.title = NSLocalizedString("calculator", comment: "Cal")
        
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem  = editButton
        
        viewsLayout()
        
        
    }
    
    public func viewsLayout() {
        
        
        
        self.view.addSubview(wrapper)
        
        
        wrapper.edgesToSuperview(excluding: .bottom, insets: .top(10) + .left(10) + .right(10), isActive: true, usingSafeArea: true)
       
    
        
   
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        
         dismiss(animated: true, completion: nil)
    }
    @objc func edit(_ edit: UIBarButtonItem) {
        pressEquals()
        delegate?.valueReturn(value: txtCalDisplay.text!)
        dismiss(animated: true, completion: nil)
    }
    
    func updateDisplay(digit:String) {
        txtCalDisplay.text = "\(txtCalDisplay.text ?? "")\(digit)"
        setCursorToTheEnd()
    }
    func resetDisplay(digit:String) {
        txtCalDisplay.text = "\(digit)"
    }

    func operatorAlreadyExist() -> Bool{
        
        let text = txtCalDisplay.text!
        if(text.count > 0) {
            let count = text.count - 1
            
            return ( text[count] == "+"
                || text[count] == "-"
                || text[count] == "*"
                || text[count] == "÷")
        } else {
            return false
        }
    }
    
    func lastInputIsDot() -> Bool{
        
        let text = txtCalDisplay.text!
        if(text.count > 0) {
            let count = text.count - 1
            
            return ( text[count] == ".")
        } else {
            return false
        }
    }
    
    func dotExitInCurrentNumber(text:String) -> Bool {
        
        var count = text.count - 1
        var dotFound = false
        while count >= 0 {
            if text[count] == "." {
                dotFound = true
            }
            if( text[count] == "+"
                || text[count] == "-"
                || text[count] == "*"
                || text[count] == "÷"){
                break
            }
            
            count = count - 1
        }
        
        return dotFound
    }
    func canAddDot() -> Bool {
        
        return !dotExitInCurrentNumber(text: txtCalDisplay.text)
       
    }
    
    func processButtonPress(val: String) {
        
        
        if (val == ".") {
           
            if canAddDot() {
                updateDisplay(digit: val)
            }
            return
        }
        
        if (val=="0" ||
            val=="1" ||
            val=="2" ||
            val=="3" ||
            val=="4" ||
            val=="5" ||
            val=="6" ||
            val=="7" ||
            val=="8" ||
            val=="9"  ) {
            
            updateDisplay(digit: val)
            firstValue = false
        }
    
        switch val {
        case "÷":
            pressDivide(val: val)
        case "+":
            pressPlus(val: val)
            
        case "-":
            pressMinus(val: val)
            firstValue = false
        case "*":
            pressDivide(val: val)
        case "=":
            pressEquals()
        default:
            break
        }
        
    }
    
    func getDisplayValue() -> Double {
        
        return (UtilsIsm.readNumberInput(value: txtCalDisplay.text!) ?? 0.0)
    }
    
    func pressEquals() {
        
        
        var fromDisplay:String = String(txtCalDisplay.text!)
        
        while lastInputIsDot() || operatorAlreadyExist() {
            
            let lastIndex = fromDisplay.count - 1
            txtCalDisplay.text = String(fromDisplay.prefix(lastIndex))
            
            fromDisplay = String(txtCalDisplay.text!)
        }
     
        var stringWithMathematicalOperation: String = fromDisplay
        if !fromDisplay.contains(".") {
            stringWithMathematicalOperation =  "\(fromDisplay).0"
        }
        stringWithMathematicalOperation = stringWithMathematicalOperation
                                                                 .replacingOccurrences(of: "÷", with: "/")
        
        /**
         .replacingOccurrences(of: ".*", with: ".0*")
         .replacingOccurrences(of: ".÷", with: ".0÷")
         .replacingOccurrences(of: ".+", with: ".0+")
         .replacingOccurrences(of: ".-", with: ".0-")
         */
 
        
        
        if stringWithMathematicalOperation.count <= 0 {
            return
        }
        
        let exp: NSExpression = NSExpression(format: stringWithMathematicalOperation)
    
        let result: Double = exp.expressionValue(with: nil, context: nil) as! Double
        
        txtCalDisplay.text = UtilsIsm.roundNumber(value: result)
        

    }
    
    func pressMultiply(val:String) {
        
        if !firstValue  && !operatorAlreadyExist() {
            
            updateDisplay(digit: val)
        }
    }
    
    func pressDivide(val:String) {
        if !firstValue && !operatorAlreadyExist() {
            updateDisplay(digit: val)
        }
    }
    
    func pressMinus(val:String) {
        if !operatorAlreadyExist() {
            updateDisplay(digit: val)
        }
        
    }
    
    
    func pressPlus(val:String) {
        if !firstValue && !operatorAlreadyExist() {
            updateDisplay(digit: val)
        }
    }
    
    func setCursorToEnd() {
        let newPosition = txtCalDisplay.endOfDocument
        txtCalDisplay.selectedTextRange = txtCalDisplay.textRange(from: newPosition, to: newPosition)
    }
    
    func setCursorToTheEnd() {
        let newPosition = txtCalDisplay.endOfDocument
        
        txtCalDisplay.selectedTextRange = txtCalDisplay.textRange(from: newPosition, to: newPosition)
        
    }
    
    
    func getCursorPost() -> Int {
        let cursorPosition = 0
        if let selectedRange = txtCalDisplay.selectedTextRange {
            // cursorPosition is an Int
            _ = txtCalDisplay.offset(from: txtCalDisplay.beginningOfDocument, to: selectedRange.start)
        }
        
        return cursorPosition
    }
    

    
}
