//
//  MeasurementView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/27/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class MeasurementView: UIView {
	// TODO class variable?
	private let externalBoundsX = 40.0 as CGFloat
	private let externalBoundsY = 20.0 as CGFloat
	
	// TODO class variable?
	private var traceColor = UIColor.blackColor()
	private var fontColor = UIColor.whiteColor()
	
	private var point1 = CGPoint(x: 10, y: 10)
	private var point2 = CGPoint(x: 10, y: 10)
	
	private var zoomScale = CGFloat()
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initMeasurementView()
	}
	
	override init() {
		super.init()
		initMeasurementView()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initMeasurementView()
	}
	
	func initMeasurementView() {
		self.backgroundColor = UIColor.clearColor()
	}
	
	func setColors(#traceColor: UIColor, fontColor:UIColor) {
		self.traceColor = traceColor
		self.fontColor = fontColor
		setNeedsDisplay()
	}
	
	func setPoints(point1: CGPoint, point2: CGPoint, zoomScale: CGFloat) {
		self.zoomScale = zoomScale
		let minX = min(point1.x, point2.x)
		let maxX = max(point1.x, point2.x)
		let minY = min(point1.y, point2.y)
		let maxY = max(point1.y, point2.y)
		
		let positionInSuperview = CGPoint(x: minX - externalBoundsX, y: minY - externalBoundsY)
		
		self.point1 = CGPoint(x: point1.x - positionInSuperview.x, y: point1.y - positionInSuperview.y)
		self.point2 = CGPoint(x: point2.x - positionInSuperview.x, y: point2.y - positionInSuperview.y)
		
		frame = CGRect(x: positionInSuperview.x,
						y: positionInSuperview.y,
					width: maxX - minX + 2 * externalBoundsX,
					height: maxY - minY + 2 * externalBoundsY)
		self.setNeedsDisplay()
	}
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(contextRef, traceColor.CGColor)
		CGContextSetStrokeColorWithColor(contextRef, traceColor.CGColor)
		
		// the first +
		CGContextMoveToPoint(contextRef, point1.x - 10, point1.y)
		CGContextAddLineToPoint(contextRef, point1.x - 1, point1.y)
		CGContextMoveToPoint(contextRef, point1.x + 10, point1.y)
		CGContextAddLineToPoint(contextRef, point1.x + 1, point1.y)
		CGContextMoveToPoint(contextRef, point1.x, point1.y - 10)
		CGContextAddLineToPoint(contextRef, point1.x, point1.y - 1)
		CGContextMoveToPoint(contextRef, point1.x, point1.y + 10)
		CGContextAddLineToPoint(contextRef, point1.x, point1.y + 1)
		CGContextStrokePath(contextRef)
		
		// the second +
		CGContextMoveToPoint(contextRef, point2.x - 10, point2.y)
		CGContextAddLineToPoint(contextRef, point2.x - 1, point2.y)
		CGContextMoveToPoint(contextRef, point2.x + 10, point2.y)
		CGContextAddLineToPoint(contextRef, point2.x + 1, point2.y)
		CGContextMoveToPoint(contextRef, point2.x, point2.y - 10)
		CGContextAddLineToPoint(contextRef, point2.x, point2.y - 1)
		CGContextMoveToPoint(contextRef, point2.x, point2.y + 10)
		CGContextAddLineToPoint(contextRef, point2.x, point2.y + 1)
		CGContextStrokePath(contextRef)
		
		// the rectangle
		// two vertical lines
		if point1.x < point2.x {
			CGContextMoveToPoint(contextRef, point1.x + 1, point1.y)
			CGContextAddLineToPoint(contextRef, point2.x - 1, point1.y)
			
			CGContextMoveToPoint(contextRef, point1.x + 1, point2.y)
			CGContextAddLineToPoint(contextRef, point2.x - 1, point2.y)
		} else {
			CGContextMoveToPoint(contextRef, point1.x - 1, point1.y)
			CGContextAddLineToPoint(contextRef, point2.x + 1, point1.y)
			
			CGContextMoveToPoint(contextRef, point1.x - 1, point2.y)
			CGContextAddLineToPoint(contextRef, point2.x + 1, point2.y)
		}
		
		// two horizontal lines
		if point1.y < point2.y {
			CGContextMoveToPoint(contextRef, point1.x, point1.y + 1)
			CGContextAddLineToPoint(contextRef, point1.x, point2.y - 1)
			
			CGContextMoveToPoint(contextRef, point2.x, point1.y + 1)
			CGContextAddLineToPoint(contextRef, point2.x, point2.y - 1)
		} else {
			CGContextMoveToPoint(contextRef, point1.x, point1.y - 1)
			CGContextAddLineToPoint(contextRef, point1.x, point2.y + 1)
			
			CGContextMoveToPoint(contextRef, point2.x, point1.y - 1)
			CGContextAddLineToPoint(contextRef, point2.x, point2.y + 1)
		}
		
		CGContextStrokePath(contextRef)
		
		
		// the text
		let attribs = [NSForegroundColorAttributeName : fontColor, NSFontAttributeName : UIFont.boldSystemFontOfSize(10)]
		
		let textString = String(format:"Δx: %d Δy: %d", Int(abs((point1.x - point2.x) / zoomScale)), Int(abs((point1.y - point2.y) / zoomScale)))
		var text = NSAttributedString(string: textString, attributes: attribs)
		
		let textSize = text.size();
		let textPosition = CGPointMake((rect.width/2 - textSize.width/2), 1)
		
		// the background
		let backgroundHeight = 16.0 as CGFloat
		// circle 1
		CGContextAddEllipseInRect(contextRef, CGRect(x: textPosition.x - backgroundHeight / 2, y: 0, width: backgroundHeight, height: backgroundHeight))
		CGContextFillPath(contextRef)
		// circle 2
		CGContextAddEllipseInRect(contextRef, CGRect(x: textPosition.x + textSize.width - backgroundHeight / 2, y: 0, width: backgroundHeight, height: backgroundHeight))
		CGContextFillPath(contextRef)
		// rectangle
		CGContextMoveToPoint(contextRef, textPosition.x, 0)
		CGContextAddLineToPoint(contextRef, textPosition.x + textSize.width, 0)
		CGContextAddLineToPoint(contextRef, textPosition.x + textSize.width, backgroundHeight)
		CGContextAddLineToPoint(contextRef, textPosition.x, backgroundHeight)
		CGContextClosePath(contextRef)
		CGContextFillPath(contextRef)
		
		
		text.drawAtPoint(textPosition)
	}
}
