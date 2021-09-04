//
//  CalculatorViewController.swift
//  ToolsBoxModule
//
//  Created by ARMEL KOUDOUM on 12/8/20.
//

import UIKit

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

public protocol CalDelegate: class {
    func onCalResult(value: String)
}


public class CalculatorViewController: UIViewController {

  
    public weak var delegate:CalDelegate?
    
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
    
    @IBOutlet weak var txtCalDisplay:UITextField!
    @IBOutlet weak var cleanBtn:UIButton!
    @IBOutlet weak var cleanAllBtn:UIButton!
    @IBOutlet weak var numberZeroBtn:UIButton!
    @IBOutlet weak var number1Btn:UIButton!
    @IBOutlet weak var number2Btn:UIButton!
    @IBOutlet weak var number3Btn:UIButton!
    @IBOutlet weak var number4Btn:UIButton!
    @IBOutlet weak var number5Btn:UIButton!
    @IBOutlet weak var number6Btn:UIButton!
    @IBOutlet weak var number7Btn:UIButton!
    @IBOutlet weak var number8Btn:UIButton!
    @IBOutlet weak var number9Btn:UIButton!
    @IBOutlet weak var numberPlusBtn:UIButton!
    @IBOutlet weak var numberMinusBtn:UIButton!
    @IBOutlet weak var numberMulBtn:UIButton!
    @IBOutlet weak var numberDotBtn:UIButton!
    @IBOutlet weak var numberEqualBtn:UIButton!
    @IBOutlet weak var numberDivBtn:UIButton!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var applyButton:UIButton!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
        
        setupViews()
    }
    
    func setupViews() {
        
        txtCalDisplay.text = "0.0"
        cleanBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        cleanAllBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        numberZeroBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number1Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number2Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number3Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number4Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number5Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number6Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number7Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number8Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        number9Btn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        numberPlusBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        numberMinusBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        numberMulBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        numberDotBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        numberEqualBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        numberDivBtn.addTarget(self, action: #selector(clenTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
    }

    @objc func cancel(_ sender: UIBarButtonItem) {
        
         dismiss(animated: true, completion: nil)
    }
    @objc func edit(_ edit: UIBarButtonItem) {
        pressEquals()
        delegate?.onCalResult(value: roundDecimal(value: Double(txtCalDisplay.text!) ?? 0))
        txtCalDisplay.text = "0.0"
        firstValue = true
        dismiss(animated: true, completion: nil)
    }
    
    func updateDisplay(digit:String) {
        txtCalDisplay.text = "\(txtCalDisplay.text ?? "")\(digit)"
        setCursorToTheEnd()
    }
    func resetDisplay(digit:String) {
        txtCalDisplay.text = "\(digit)"
    }
    
    @objc func clenTapped(event:UIButton) {
       
        if(firstValue) {
            txtCalDisplay.text = ""
        }
        
        if event.titleLabel?.text == "CE" {
            
            if firstValue {
                 return
            }
            
            let fromDisplay:String = String(txtCalDisplay.text!)
            let lastIndex = fromDisplay.count - 1
            txtCalDisplay.text = String(fromDisplay.prefix(lastIndex))
        
            if(txtCalDisplay.text?.count ?? 0 <= 0) {
                firstValue = true
            }
            
            return
        }
        
        if event.titleLabel?.text == "CA" {
            txtCalDisplay.text = "0.0"
            firstValue = true
            return
        }
        
        
        processButtonPress(val: event.titleLabel?.text! ?? "")
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
        
        return !dotExitInCurrentNumber(text: txtCalDisplay.text ?? "")
       
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
        
        return Double(txtCalDisplay.text!) ?? 0
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
        
        txtCalDisplay.text = "\(result)"
        

    }
        
    func roundDecimal(value: Double) -> String{
        return "\(Double(round(1000*value)/1000))"
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
