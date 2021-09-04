//
//  ProgressCircleView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/2/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import Darwin

public class ProgressCircleView: UIView {
    
    let pi:Double = Double.pi
    let tickness:Double = 5.0
    
    var maxVal:Double = 0.0
    var spentVal:Double = 0.0
    var incomeVal:Double  = 0.0
    var localCode: String = ""
    //var pref:MyPreferences!
    
    var Letter:String = ""
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        //self.pref = MyPreferences()
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        //self.pref = MyPreferences()
    }
    
    public override func draw(_ rect: CGRect) {
        
        
        let valueSaved =  self.incomeVal - self.spentVal
        
        //print("Values \(self.incomeVal) \(self.spentVal) \(valueSaved) \(self.pref.getCurrency())")
        
        self.Letter = UtilsIsm.formartCurrency(value: valueSaved, local: self.localCode)
        
        let saving:String = self.Letter
        
        //text settings
        /**  /////           */
        let s: NSString = self.Letter as NSString
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.darkGray
        
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Helvetica", size: 16)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        
        // set the Obliqueness to 0.1
        let skew = 0.0
        
        let attributes: NSDictionary = [
            NSAttributedString.Key.foregroundColor: fieldColor,
            NSAttributedString.Key.paragraphStyle: paraStyle,
            NSAttributedString.Key.obliqueness: skew,
            NSAttributedString.Key.font: fieldFont!
        ]
        
        /////
        
        var sText: NSString = NSLocalizedString("statSaving", comment: "Saving") as NSString
        
        if valueSaved < 0 {
            sText = NSLocalizedString("statDebt", comment: "Debt") as NSString
        }
        // set the text color to dark gray
        let fieldColor2: UIColor = UIColor.lightGray
        
        // set the font to Helvetica Neue 18
        let fieldFont2 = UIFont(name: "Helvetica", size: 16)
        
        // set the line spacing to 6
        let paraStyle2 = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        
        // set the Obliqueness to 0.1
        let skew2 = 0.0
        
        let attributes2: NSDictionary = [
            NSAttributedString.Key.foregroundColor: fieldColor2,
            NSAttributedString.Key.paragraphStyle: paraStyle2,
            NSAttributedString.Key.obliqueness: skew2,
            NSAttributedString.Key.font: fieldFont2!
        ]
        
        
        //End text settings
        /*******************************/
        
        var raduis: CGFloat = 0.0
        
        if rect.height<rect.width {
            raduis = rect.height/2 - 4.0
        } else {
            raduis = rect.width/2 - 4.0
        }
        
        let centerX = raduis + CGFloat(tickness)
        let centerY = rect.height/2
        
        //first full circle
        let color:UIColor = UIColor(white:0.96, alpha:1.0)
        let circlePath:UIBezierPath  =  UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius:
            CGFloat(raduis), startAngle: CGFloat(0), endAngle: CGFloat(pi*2), clockwise: true)
        circlePath.lineWidth = 5.0
        color.set()
        circlePath.stroke()
        
        
        
        ///arc
        var angle:Double
        
        if self.incomeVal > 0 {
            
            angle = self.spentVal*2/self.incomeVal
        } else {
            
            angle = 2
        }
        
        
        if angle > 2 {
            angle = 2
        }
        
        print("angle in pi \(angle)")
        
        
        let h = rect.height
        let w = rect.width
        
        let size_amount:CGSize =  s.size(withAttributes: attributes as? [NSAttributedString.Key : Any])
        let size_label:CGSize =  sText.size(withAttributes: attributes2 as? [NSAttributedString.Key : Any])
        
        let mRectSave = CGRect(x: h*0.5 - size_label.width*0.5,y: (h * 0.25),width: (size_label.width),height: size_label.height)
        let mRect = CGRect(x: h*0.5 - size_amount.width*0.5,y: (h*0.5 - size_amount.height*0.40),width: (size_amount.width),height: size_amount.height)
        
        
        
        if self.incomeVal>0 || self.spentVal>0 {
            //draw arc
            let colorSecond:UIColor =  UIColor(red:0.22, green:0.62, blue:0.23, alpha:1.0)
            let fullCirclePath:UIBezierPath  = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius:
                CGFloat(raduis), startAngle: CGFloat(pi), endAngle: CGFloat(angle*pi + pi), clockwise: true)
            fullCirclePath.lineWidth = 5.0
            colorSecond.set()
            fullCirclePath.stroke()
            
        }
        ///draw text
        
        s.draw(in: mRect, withAttributes: attributes as? [NSAttributedString.Key : Any])
        
        sText.draw(in: mRectSave, withAttributes: attributes2 as? [NSAttributedString.Key : Any])
        
    }
    
    public func reDraw(_ max: Double , spent:Double, income:Double, localCd: String) {
        
        self.localCode = localCd
        self.maxVal = max
        self.spentVal = spent
        self.incomeVal = income
        
    }
    
}
