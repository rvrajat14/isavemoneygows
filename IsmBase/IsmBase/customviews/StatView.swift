//
//  StatView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/12/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit
import Darwin

public class StatView: UIView {
    let pi:Double = Double.pi
    let tickness:Double = 9.0
    
    var maxVal:Double = 0.0
    var spentVal:Double = 0.0
    var incomeVal:Double  = 0.0
    var localCode: String = "en_US"
    //var formatter: NumberFormatter!
    
    var Letter:String = ""
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        //formatter = NumberFormatter()
        //formatter.numberStyle = .currency
       
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        
        let valueSaved =  self.incomeVal - self.spentVal
        
        //print("Values \(self.incomeVal) \(self.spentVal) \(valueSaved) \(self.pref.getCurrency())")
        
        self.Letter = UtilsIsm.formartCurrency(value: valueSaved, local: self.localCode)
        
        
        //text settings
        /**  /////           */
        let s: NSString = self.Letter as NSString
        // set the text color to dark gray
        
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Helvetica", size: 16)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        
        // set the Obliqueness to 0.1
        let skew = 0.0
        
        let attributes: NSDictionary = [
            NSAttributedString.Key.foregroundColor: Const.blueText,
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
        let fieldFont2 = UIFont(name: "Helvetica", size: 12)
        
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
        
        
        let raduis: CGFloat = rect.height - CGFloat(self.tickness)
        
        /*if rect.height<rect.width {
            raduis = rect.height/2 - 4.0
        } else {
            raduis = rect.width/2 - 4.0
        }*/
        
        let centerX =  rect.width/2  //raduis + CGFloat(tickness)
        let centerY = rect.height
        
        //first full circle
        let color:UIColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        let circlePath:UIBezierPath  =  UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius:
            CGFloat(raduis), startAngle: CGFloat(pi), endAngle: CGFloat(pi*2), clockwise: true)
        circlePath.lineWidth = CGFloat(tickness + 2)
        color.set()
        circlePath.stroke()
        
        let color1:UIColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.0)
        let circlePath1:UIBezierPath  =  UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius:
            CGFloat(raduis), startAngle: CGFloat(pi), endAngle: CGFloat(pi*2), clockwise: true)
        circlePath1.lineWidth = CGFloat(tickness)
        color1.set()
        circlePath.stroke()
        
        
        
        ///arc
        var angle:Double
        
        if self.incomeVal > 0 {
            
            angle = self.spentVal/self.incomeVal
        } else {
            
            angle = 1
        }
            
        
        if angle > 1 {
            angle = 1
        }
        
        print("angle in pi \(angle)")
        

        
        let h = rect.height
        let w = rect.width
        
        let size_amount:CGSize =  s.size(withAttributes: attributes as? [NSAttributedString.Key : Any])
        let size_label:CGSize =  sText.size(withAttributes: attributes2 as? [NSAttributedString.Key : Any])
        
    
        
        let mRectSave = CGRect(x: w*0.5 - size_label.width*0.5,y: (h * 0.55),width: (size_label.width),height: size_label.height)
        let mRect = CGRect(x: w*0.5 - size_amount.width*0.5,y: (h*0.85 - size_amount.height*0.40),width: (size_amount.width),height: size_amount.height)
        
        
        
        if self.incomeVal>0 || self.spentVal>0 {
        //draw arc
        var colorSecond:UIColor =  Const.graphicsColor
            
        if (self.incomeVal - self.spentVal) < 0 {
            colorSecond = Const.RED
        }
        
            //UIColor(red:0.22, green:0.62, blue:0.23, alpha:1.0)
        let fullCirclePath:UIBezierPath  = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius:
            CGFloat(raduis), startAngle: CGFloat(pi), endAngle: CGFloat(angle*pi + pi), clockwise: true)
        fullCirclePath.lineWidth = CGFloat(tickness)
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
