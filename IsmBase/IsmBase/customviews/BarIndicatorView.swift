//
//  BarIndicatorView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/12/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit

public class BarIndicatorView: UIView {
    
    var maxVal:Double=0.0
    var spentVal:Double=0.0
    var colorProgress:UIColor!
    var color:UIColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    let pi:Double = M_PI
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        colorProgress = Const.graphicsColor
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        colorProgress = Const.graphicsColor
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        print("budget \(self.maxVal) spent \(self.spentVal)")
        /* First rect*/
        let rectLenght = rect.width
        let h = rect.height
        
        
        //first rect
        let rectBody = rectLenght
    
        
        let rectFull = CGRect(x: 0, y: 0, width: rectBody, height: h )
        let rectBodyDraw:UIBezierPath = UIBezierPath(roundedRect: rectFull, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 5.0, height: 0.0))
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
    
        //Progress part

        
        let rectFull1 = CGRect(x: 0, y: 0, width: rectLenghtSecond, height: h2 )
        let rectBodyDraw1:UIBezierPath = UIBezierPath(roundedRect: rectFull1, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 5.0, height: 0.0))
        
        if (self.maxVal - self.spentVal)<0 {
            
            self.colorProgress = Const.RED
        }
        self.colorProgress.set()
        rectBodyDraw1.fill()
        
        
    }
    
    
    public func reDraw(_ max: Double , spent:Double, color:UIColor) {
        
        self.maxVal = max
        self.spentVal = spent
        self.colorProgress = color
        
    
    }
    
    public func reDraw(_ max: Double , spent:Double, color:UIColor, bgColor:UIColor) {
        
        self.maxVal = max
        self.spentVal = spent
        self.colorProgress = color
        self.color = bgColor
        
        
    }


}
