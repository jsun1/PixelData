//
//  RulerView.swift
//  Pixel Data
//
//  Created by Jeffrey Sun on 9/26/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class RulerView: UIView {
    
    var hasImage = false
    var zoomScale : CGFloat = CGFloat(1) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var offset : CGPoint = CGPointMake(0, 0) {
        didSet {
            self.setNeedsDisplay()
        }
    }    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        if !hasImage {
            self.zoomScale = 10;
        }
        var widthOfTen = 10 * zoomScale
        
        var multiplier = 1
        while widthOfTen < 40 {
            multiplier += 1
            widthOfTen = 10 * zoomScale * CGFloat(multiplier)
        }
        
        var displayText = false
        var darkColor = UIColor.darkGrayColor().CGColor
        var lightColor = UIColor.lightGrayColor().CGColor
        if widthOfTen > 40 {
            darkColor = UIColor.blackColor().CGColor
            lightColor = UIColor.darkGrayColor().CGColor
            
            displayText = true
        }
        var pixelCount = 0
        let attribs = [NSForegroundColorAttributeName : UIColor.grayColor(), NSFontAttributeName : UIFont.systemFontOfSize(10)]
        
        let context = UIGraphicsGetCurrentContext()
        if (self.frame.size.width > self.frame.size.height) {
            let half = self.frame.size.height/2
            var x = -offset.x
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
                if displayText {
                    let text = NSAttributedString(string : String(pixelCount), attributes: attribs)
                    text.drawAtPoint(CGPointMake(x, 0))
                }
                pixelCount += 10 * multiplier
                x += widthOfTen
            }
            CGContextStrokePath(context)
        } else {
            let half = self.frame.size.width/2
            var y = -offset.y
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
//                if displayText {
//                    let text = NSAttributedString(string : String(pixelCount), attributes: attribs)
//                    text.drawAtPoint(CGPointMake(0, y))
//                }
//                pixelCount += 10 * multiplier
                y += widthOfTen
            }
            CGContextStrokePath(context)
            if displayText {
                CGContextRotateCTM (context, CGFloat(-M_PI_2))
                y = -offset.y
                while (y < self.frame.size.height) {
                    let text = NSAttributedString(string : String(pixelCount), attributes: attribs)
                    text.drawAtPoint(CGPointMake(-y, 0))
                    pixelCount += 10 * multiplier
                    y += widthOfTen
                }
            }
            
        }
        
        
    }

}







