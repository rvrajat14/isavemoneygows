//
//  ColorView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/12/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
public class ColorView: UIView {
    
    var color:UIColor!
    var chked = false
    var checkedSize = CGFloat(4.0)
    let checkedColor:UIColor = Const.whiteText
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        color = UIColor(red:0.22, green:0.62, blue:0.23, alpha:1.0)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        let l = rect.width
        let h = rect.height
        
        checkedSize = round(l/2)
        
        let rectFull = CGRect(x: 0, y: 0, width: l, height: h )
        let rectBodyDraw:UIBezierPath = UIBezierPath(rect: rectFull)
        color.set()
        rectBodyDraw.fill()
        
        if self.chked {
            let xOrigine = l/2 - CGFloat(checkedSize/2)
            let yOrigine = h/2 - CGFloat(checkedSize/2)
            let checkRect = CGRect(x: xOrigine, y: yOrigine, width: CGFloat(checkedSize) , height: CGFloat(checkedSize))
             let checkRectDraw:UIBezierPath = UIBezierPath(rect: checkRect)
            checkedColor.set()
            checkRectDraw.fill()
            
        }
    }
    
    
    public func reDraw(color:UIColor, checked:Bool) {
        
        self.color = color
        self.chked = checked
        
    }
    
}
