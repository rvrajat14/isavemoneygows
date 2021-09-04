//
//  CircleTextUIView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/5/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public class CircleTextUIView: UIView {

    let pi:Double = M_PI
    let tickness:Double = 0.0
    var color:UIColor = UIColor(named: "progressBaseColor") ?? UIColor(red: 0.56, green: 0.80, blue: 0.89, alpha: 1.00)
    
    var mRect:CGRect!
    var Letter:String = "O"
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
    }
    
    public override func draw(_ rect: CGRect) {
    
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.white
        
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: IsmFontFamily.DmsansBold, size: IsmDimems.circleTextSize)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        
        // set the Obliqueness to 0.1
        let skew = 0.0
        
        let attributes: NSDictionary = [
            NSAttributedString.Key.foregroundColor: fieldColor,
            NSAttributedString.Key.paragraphStyle: paraStyle,
            NSAttributedString.Key.obliqueness: skew,
            NSAttributedString.Key.font: fieldFont ?? UIFont(name: "Helvetica", size: IsmDimems.circleTextSize)
        ]
        ////////
        let s: NSString = Letter.uppercased() as NSString
        
        var raduis: CGFloat = 0.0
        
        if rect.height<rect.width {
            raduis = rect.height/2
        } else {
            raduis = rect.width/2
        }
        
        let centerX = raduis + CGFloat(tickness)
        let centerY = rect.height/2
        
        
        //////////begin
        let h = rect.height
        let w = rect.width
        
        
        
        let size:CGSize =  s.size(withAttributes: attributes as? [NSAttributedString.Key : Any])
        
        //print("String size \(h)  text h \(size.height)")
        mRect = CGRect(x: (w - size.width)*0.5, y: (h - size.height)*0.75, width: size.width, height: size.height)
        
        let bpath:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius:
            CGFloat(raduis), startAngle: CGFloat(0), endAngle: CGFloat(pi*2), clockwise: true)
        
        color.set()
        
        bpath.fill()
        
        //////////end
        s.draw(in: mRect, withAttributes: attributes as? [NSAttributedString.Key : Any])
        

    }
    
    public func setText(text: String) {
        
        Letter = text
        
    }
    
    public func setText(text: String, col:UIColor) {
        
        Letter = text
        color = col
    }
    
    
    

}
