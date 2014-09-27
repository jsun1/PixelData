//
//  ColorPinView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/26/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class ColorPinView: UIView {
	let width = 50.0 as CGFloat
	let height = 60.0 as CGFloat
	
	let circleRadius = 20.0 as CGFloat
	
	var color: CGColorRef = UIColor.whiteColor().CGColor {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(contextRef, UIColor.blackColor().CGColor)
		CGContextMoveToPoint(contextRef, 0, 10 + circleRadius)
		CGContextAddLineToPoint(contextRef, width / 2, height)
		CGContextAddLineToPoint(contextRef, width, 10 + circleRadius)
		CGContextClosePath(contextRef)
		CGContextFillPath(contextRef)
		
		CGContextAddEllipseInRect(contextRef, CGRect(x: 0, y: 0, width: width, height: width))
		CGContextFillPath(contextRef)
		
		CGContextAddEllipseInRect(contextRef, CGRect(x: 5, y: 5, width: 2 * circleRadius, height: 2 * circleRadius))
		CGContextSetFillColorWithColor(contextRef, color)
		CGContextFillPath(contextRef)
	}
}