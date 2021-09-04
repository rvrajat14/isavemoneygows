//
//  TopRoundView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/28/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class TopRoundView: UIView {
    
    var colorTint:UIColor!
    let pi:Double = Double.pi
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        /* First rect*/
        let rectLenght = rect.width
        let h = rect.height
        let color:UIColor = Const.whiteText
        //UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        //first rect
        let rectBody = rectLenght
        
        
        let rectFull = CGRect(x: 0, y: 0, width: rectBody, height: h )
        let rectBodyDraw:UIBezierPath = UIBezierPath(roundedRect: rectFull, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 10.0, height: 0.0))
        color.set()
        rectBodyDraw.fill()
        
    }
    
    
    internal func reDraw(color:UIColor) {
        
        self.colorTint = color
        
    }
    
}
