//
//  RulerView.swift
//  Pixel Data
//
//  Created by Jeffrey Sun on 9/26/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class RulerView: UIView {

    var isHorizontal = true
    
    var offset = CGPointMake(0, 0)
    var scale = 1
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    
        var begin = CGFloat(0)
        var end = CGFloat(300)
        
        let length = end - begin
        //at my x = 0, pixel is begin
        //at my y = width, pixel is end
        if (length > self.frame.size.width) {
            
            
            
        }
        
        let widthOfTen = CGFloat(40) //want this to be between 20 and 40
        
        var darkColor = UIColor.darkGrayColor().CGColor
        var lightColor = UIColor.lightGrayColor().CGColor
        if widthOfTen > 40 {
            darkColor = UIColor.blackColor().CGColor
            lightColor = UIColor.darkGrayColor().CGColor
        }
        
        let context = UIGraphicsGetCurrentContext()
        if (self.frame.size.width > self.frame.size.height) {
            let half = self.frame.size.height/2
            var x = CGFloat(0)
            while (x < self.frame.size.width) {
                CGContextSetLineWidth(context, 1.0);
                CGContextSetStrokeColorWithColor(context, darkColor)
                CGContextMoveToPoint(context, x, half)
                CGContextAddLineToPoint(context, x, self.frame.size.height)
                CGContextSetStrokeColorWithColor(context, lightColor)
                CGContextSetLineWidth(context, 0.5);
                for var i = CGFloat(0); i < 10; i++ {
                    if i == CGFloat(5) {
                        CGContextMoveToPoint(context, x + i * (widthOfTen / 10), half * 1.25)
                    } else {
                        CGContextMoveToPoint(context, x + i * (widthOfTen / 10), half * 1.5)
                    }
                    CGContextAddLineToPoint(context, x + i * (widthOfTen / 10), self.frame.size.height)
                }
                x += widthOfTen
            }
        } else {
            let half = self.frame.size.width/2
            var y = CGFloat(0)
            while (y < self.frame.size.height) {
                CGContextSetLineWidth(context, 1.0);
                CGContextSetStrokeColorWithColor(context, darkColor)
                CGContextMoveToPoint(context, half, y)
                CGContextAddLineToPoint(context, self.frame.size.width, y)
                CGContextSetStrokeColorWithColor(context, lightColor)
                CGContextSetLineWidth(context, 0.5);
                for var i = CGFloat(0); i < 10; i++ {
                    if i == CGFloat(5) {
                        CGContextMoveToPoint(context, half * 1.25, y + i * (widthOfTen / 10))
                    } else {
                        CGContextMoveToPoint(context, half * 1.5,  y + i * (widthOfTen / 10))
                    }
                    CGContextAddLineToPoint(context, self.frame.size.width, y + i * (widthOfTen / 10))
                }
                y += widthOfTen
            }
        }
        CGContextStrokePath(context)
        
        
    }

}







