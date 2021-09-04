//
//  SimpleView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/17/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit

public class SimpleView: UIView {

    var maxVal:Double!
    var spentVal:Double!
    var colorProgress:UIColor!
    let pi:Double = Double.pi
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        colorProgress = UIColor(red:0.22, green:0.62, blue:0.23, alpha:1.0)
        
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        //First rect
        /*let width =  rect.width
         let color:UIColor = UIColor(white:0.96, alpha:1.0)
         let rectFull = CGRect(x: 0, y: 0, width: width, height: rect.height )
         let bpath:UIBezierPath = UIBezierPath(rect: rectFull)
         color.set()
         bpath.fill()*/
        
        
        /////////////////////
        
        let rectLenght = rect.width
        let h = rect.height
        let color:UIColor = UIColor(white:0.96, alpha:1.0)
        if(rectLenght <= h) {
            
            //drawCircle(x: rectLenght/2, y = h/2, raduis: rectLenght/2)
            
            let circleHead:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: rectLenght/2, y: h/2), radius:
                CGFloat(rectLenght/2), startAngle: CGFloat(0), endAngle: CGFloat(pi*2), clockwise: true)
            color.set()
            circleHead.fill()
        } else {
            
            var rectBody = rectLenght - h
            
            //rect head
            //drawCircle(x: h/2, y = h/2, raduis: h/2)
            let circleHead:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: h/2, y: h/2), radius:
                CGFloat(h/2), startAngle: CGFloat(0), endAngle: CGFloat(pi*2), clockwise: true)
            color.set()
            circleHead.fill()
            
            //rect body
            if(rectBody>0){
                //drawRect(x: h/2 , y = 0 , width: rectBody, height: h)
                ///////////new
                //let rectFull = CGRect(x: h/2, y: 0, width: rectBody, height: h )
                //let bpath:UIBezierPath = UIBezierPath(rect: rectFull)
                //color.set()
                //bpath.fill()
                
            }else {
                rectBody = rectLenght - h/4
                //drawRect(x: h/2 , y = 0 , width: rectBody, height: h)
                
            }
            
            let rectFull = CGRect(x: h/2, y: 0, width: rectBody, height: h )
            let rectBodyDraw:UIBezierPath = UIBezierPath(rect: rectFull)
            color.set()
            rectBodyDraw.fill()
            
            
            //rect tail
            //drawCircle(x: (rectLenght - h/2), y = h/2, raduis: h/2)
            let circleTail:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: (rectLenght - h/2), y: h/2), radius:
                CGFloat(h/2), startAngle: CGFloat(0), endAngle: CGFloat(pi*2), clockwise: true)
            color.set()
            circleTail.fill()
            
        }
        //////////////////////
        
        
        
        
        //Second rect
        /*var rectLenghtSecond = rect.width
         if self.maxVal! > 0 {
         
         rectLenghtSecond = (rect.width * CGFloat(self.spentVal!))/CGFloat(self.maxVal!)
         
         if rectLenghtSecond > rect.width {
         
         rectLenghtSecond = rect.width
         
         }
         
         }
         let rectProgress = CGRect(x: 0, y: 0, width: rectLenghtSecond, height: rect.height)
         let bpathProgress:UIBezierPath = UIBezierPath(rect: rectProgress)
         self.colorProgress.set()
         bpathProgress.fill()*/
        
        var rectLenghtSecond = rect.width
        if self.maxVal! > 0 {
            
            rectLenghtSecond = (rect.width * CGFloat(self.spentVal!))/CGFloat(self.maxVal!)
            
            if rectLenghtSecond > rect.width {
                
                rectLenghtSecond = rect.width
                
            }
            
        }
        
        let h2 = rect.height
        if(rectLenghtSecond <= h2) {
            
            let circleHead:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: rectLenghtSecond/2, y: h2/2), radius:
                CGFloat(rectLenghtSecond/2), startAngle: CGFloat(0), endAngle: CGFloat(pi*2), clockwise: true)
            self.colorProgress.set()
            circleHead.fill()
        } else {
            
            var rectBody = rectLenghtSecond - h2
            
            let circleHead:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: h2/2, y: h2/2), radius:
                CGFloat(h2/2), startAngle: CGFloat(0), endAngle: CGFloat(pi*2), clockwise: true)
            self.colorProgress.set()
            circleHead.fill()
            
            //rect body
            if(rectBody>0){
                
            }else {
                rectBody = rectLenghtSecond - h2/4
                
            }
            
            let rectFull = CGRect(x: h2/2, y: 0, width: rectBody, height: h2 )
            let rectBodyDraw:UIBezierPath = UIBezierPath(rect: rectFull)
            self.colorProgress.set()
            rectBodyDraw.fill()
            
            let circleTail:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: (rectLenghtSecond - h2/2), y: h2/2), radius:
                CGFloat(h2/2), startAngle: CGFloat(0), endAngle: CGFloat(pi*2), clockwise: true)
            self.colorProgress.set()
            circleTail.fill()
            
        }
        
    }
    
    
    public func reDraw(_ max: Double , spent:Double, color:UIColor) {
        
        self.maxVal = max
        self.spentVal = spent
        self.colorProgress = color
        
        
    }

}
