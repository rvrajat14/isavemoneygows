//
//  LineView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/7/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
public class LineView: UIView {
    
    
    var lenght:Double!
    var color:UIColor!
    
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        color = UIColor(red:0.22, green:0.62, blue:0.23, alpha:1.0)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        let rectLenght = rect.width
        let h = rect.height

        let rectFull = CGRect(x: 0, y: 0, width: rectLenght, height: h )
        let rectBodyDraw:UIBezierPath = UIBezierPath(rect: rectFull)
        color.set()
        rectBodyDraw.fill()
    }
    
    
    public func reDraw(lenght:Double, color:UIColor) {
        
        self.lenght = lenght
        self.color = color
        
    }
    
    public func reDraw(color:UIColor) {
        
        self.color = color
        
        
    }
    
}
