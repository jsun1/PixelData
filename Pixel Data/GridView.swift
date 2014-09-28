//
//  GridView.swift
//  Pixel Data
//
//  Created by Jeffrey Sun on 9/28/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class GridView: UIView {

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
    
    var size = CGSizeMake(0, 0)
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        if !hasImage {
            self.zoomScale = 1;
        }
        var widthOfOne = 1 * zoomScale
        if (widthOfOne >= 10) {
            var darkColor = UIColor.darkGrayColor().CGColor
            var lightColor = UIColor.lightGrayColor().CGColor

            let context = UIGraphicsGetCurrentContext()
            var x = -offset.x
            while (x <= min(self.frame.size.width, -offset.x + zoomScale * size.width)) {
                CGContextSetLineWidth(context, 0.5);
                CGContextSetStrokeColorWithColor(context, lightColor)
                CGContextMoveToPoint(context, x, max(0, -offset.y))
                CGContextAddLineToPoint(context, x, min(self.frame.size.height, -offset.y + zoomScale * size.height))
                x += widthOfOne
            }
            var y = -offset.y
            while (y <= min(self.frame.size.height, -offset.y + zoomScale * size.height)) {
                CGContextSetLineWidth(context, 0.5);
                CGContextSetStrokeColorWithColor(context, lightColor)
                CGContextMoveToPoint(context, max(0, -offset.x), y)
                CGContextAddLineToPoint(context, min(self.frame.size.width, -offset.x + zoomScale * size.width), y)
                y += widthOfOne
            }
            CGContextStrokePath(context)
        }
        
        
    }

}
