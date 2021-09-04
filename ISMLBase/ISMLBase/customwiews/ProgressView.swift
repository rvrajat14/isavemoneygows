//
//  ProgressView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/5/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class ProgressView: UIView {
    
    var maxVal:Double=0.0
    var spentVal:Double=0.0
    var colorProgress:UIColor!
    let pi:Double = M_PI
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        colorProgress = UIColor(named: "progressLevelColor") ?? UIColor(red: 0.33, green: 0.41, blue: 0.79, alpha: 1.00)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        colorProgress = UIColor(named: "progressLevelColor") ?? UIColor(red: 0.33, green: 0.41, blue: 0.79, alpha: 1.00)
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        /* First rect*/
        let rectLenght = rect.width
        let h = rect.height
        let color:UIColor = UIColor(named: "progressBaseColor") ?? UIColor(red: 0.56, green: 0.80, blue: 0.89, alpha: 1.00)
        
        //first rect
        let rectBody = rectLenght
        
        
        let rectFull = CGRect(x: 0, y: 0, width: rectBody, height: h )
        let rectBodyDraw:UIBezierPath = UIBezierPath(roundedRect: rectFull, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.bottomRight, UIRectCorner.topRight], cornerRadii: CGSize(width: 5.0, height: 0.0))
        color.set()
        rectBodyDraw.fill()
        
        
        if self.maxVal == 0 && self.spentVal == 0{
            
            return
        }
        //////////////////////
        
        /* Second rect */
        
        var rectLenghtSecond = rect.width
        if self.maxVal > 0 {
            
            rectLenghtSecond = (rect.width * CGFloat(self.spentVal))/CGFloat(self.maxVal)
            
            if rectLenghtSecond > rect.width {
                
                rectLenghtSecond = rect.width
                
            }
            
        }
        
        let h2 = rect.height
        
        
        let rectFull1 = CGRect(x: 0, y: 0, width: rectLenghtSecond, height: h2 )
        let rectBodyDraw1:UIBezierPath = UIBezierPath(roundedRect: rectFull1, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.bottomRight, UIRectCorner.topRight], cornerRadii: CGSize(width: 5.0, height: 0.0))
        self.colorProgress.set()
        rectBodyDraw1.fill()
        
        
        
        let attr1: NSDictionary = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle(),
            NSAttributedString.Key.obliqueness: 0.0,
            NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 11)!
        ]
        
        let sText: NSString = NSLocalizedString("budgetedSpent", comment: "budgeted Spent") as NSString
        let size_label:CGSize =  sText.size(withAttributes: attr1 as? [NSAttributedString.Key : Any] )
        
        let labelText = CGRect(x: 10 ,y: ((h - size_label.height) * 0.5), width: (size_label.width),height: size_label.height)
        sText.draw(in: labelText, withAttributes: attr1 as? [NSAttributedString.Key : Any])
        
        
        let attr2: NSDictionary = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle(),
            NSAttributedString.Key.obliqueness: 0.0,
            NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 14)!
        ]
        
        let sPerCent: NSString = "\(round(self.spentVal/self.maxVal*100))%" as NSString
        let percent_label:CGSize =  sPerCent.size(withAttributes: attr2 as? [NSAttributedString.Key : Any])
        
        let percentText = CGRect(x: ((rectLenght - percent_label.width)*0.5) ,y: ((h - percent_label.height) * 0.5), width: (percent_label.width),height: percent_label.height)
        sPerCent.draw(in: percentText, withAttributes: attr2 as? [NSAttributedString.Key : Any])
        
    }
    
    
    public func reDraw(_ max: Double , spent:Double, color:UIColor) {
        
        self.maxVal = max
        self.spentVal = spent
       // self.colorProgress = color
        
        
    }
    
}
