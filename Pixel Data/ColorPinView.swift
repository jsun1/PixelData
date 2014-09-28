//
//  ColorPinView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/26/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class ColorPinView: UIView {
	let width = 120.0 as CGFloat
	let height = 60.0 as CGFloat
	
	let circleRadius = 20.0 as CGFloat
	
	var color: UIColor = UIColor.whiteColor() {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(contextRef, UIColor.blackColor().CGColor)
		
		// the box
		// circle 1
		CGContextAddEllipseInRect(contextRef, CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
		CGContextFillPath(contextRef)
		// circle 2
		CGContextAddEllipseInRect(contextRef, CGRect(x: width - 50.0, y: 0, width: 50.0, height: 50.0))
		CGContextFillPath(contextRef)
		// rectangle
		CGContextMoveToPoint(contextRef, 25, 0)
		CGContextAddLineToPoint(contextRef, 25, 50)
		CGContextAddLineToPoint(contextRef, width - 25, 50)
		CGContextAddLineToPoint(contextRef, width - 25, 0)
		CGContextClosePath(contextRef)
		CGContextFillPath(contextRef)
		
		// the tip
		CGContextMoveToPoint(contextRef, 0, 10 + circleRadius)
		CGContextAddLineToPoint(contextRef, width / 2, height)
		CGContextAddLineToPoint(contextRef, width, 10 + circleRadius)
		CGContextClosePath(contextRef)
		CGContextFillPath(contextRef)
		
		// white for the background
		CGContextAddEllipseInRect(contextRef, CGRect(x: 5, y: 5, width: 2 * circleRadius, height: 2 * circleRadius))
		CGContextSetFillColorWithColor(contextRef, UIColor.whiteColor().CGColor)
		CGContextFillPath(contextRef)
		
		// the actual color
		CGContextAddEllipseInRect(contextRef, CGRect(x: 5, y: 5, width: 2 * circleRadius, height: 2 * circleRadius))
		CGContextSetFillColorWithColor(contextRef, color.CGColor)
		CGContextFillPath(contextRef)
		
		// write the color elements
		var rgba = [CGFloat](count: 4, repeatedValue: 0.0)
		
		color.getRed(&rgba[0], green: &rgba[1], blue: &rgba[2], alpha: &rgba[3])
		
//		let floatVal = String(format: "%.3f, %.3f, %.3f, %.3f", Float(rgba[0]), Float(rgba[1]), Float(rgba[2]), Float(rgba[3]))
		let intVal = String(format: "R:%03.0f, G:%03.0f\nB:%03.0f, A:%03.0f", Float(rgba[0]) * 255.99999, Float(rgba[1]) * 255.99999, Float(rgba[2]) * 255.99999, Float(rgba[3]) * 255.99999)
		let hexVal = String(format: "#%02x%02x%02x%02x", Int(Float(rgba[3]) * 255.99999), Int(Float(rgba[0]) * 255.99999), Int(Float(rgba[1]) * 255.99999), Int(Float(rgba[2]) * 255.99999))
		
		
		let attribs = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.boldSystemFontOfSize(10)]
//		var text = NSAttributedString(string : String(floatVal), attributes: attribs)
//		text.drawAtPoint(CGPointMake(50, 5))
		var text = NSAttributedString(string : String(intVal), attributes: attribs)
		text.drawAtPoint(CGPointMake(48, 7))
		text = NSAttributedString(string : String(hexVal), attributes: attribs)
		text.drawAtPoint(CGPointMake(48, 32))
	}
}