//
//  ColorPinView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/26/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class ColorPinView: OverlayView {
	private let frameWidth = 120.0 as CGFloat
	private let frameHeight = 80.0 as CGFloat
	
	// TODO class variable?
	private let circleRadius = 20.0 as CGFloat
	
	private var pointInImage: CGPoint?
	
	override var zoomScale: CGFloat {
		didSet {
			if pointInImage == nil {
				return
			}
			
			var positionInSuperview = CGPoint(x: (pointInImage!.x + 0.5) * zoomScale - contentOffset.x, y: (pointInImage!.y + 0.5) * zoomScale - contentOffset.y)
			positionInSuperview.x -= frameWidth / 2
			positionInSuperview.y -= frameHeight - 20
			frame = CGRect(x: positionInSuperview.x, y: positionInSuperview.y, width: frameWidth, height: frameHeight)
		}
	}
	
	var pixelColor: UIColor = UIColor.whiteColor() {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initPinView()
	}
	
	override init() {
		super.init(frame: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight))
		initPinView()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initPinView()
	}
	
	func initPinView() {
	}
	
	func setPoint(point: CGPoint, zoomScale: CGFloat, contentOffset: CGPoint) {
		self.contentOffset = contentOffset
		pointInImage = CGPoint(x: floor(point.x/zoomScale), y: floor(point.y/zoomScale))
		self.zoomScale = zoomScale
	}
	
	func getPointInImage() -> CGPoint? {
		return pointInImage
	}
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(contextRef, traceColor.CGColor)
		CGContextSetStrokeColorWithColor(contextRef, traceColor.CGColor)
		
		// the box
		// circle 1
		CGContextAddEllipseInRect(contextRef, CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
		CGContextFillPath(contextRef)
		// circle 2
		CGContextAddEllipseInRect(contextRef, CGRect(x: rect.width - 50.0, y: 0, width: 50.0, height: 50.0))
		CGContextFillPath(contextRef)
		// rectangle
		CGContextMoveToPoint(contextRef, 25, 0)
		CGContextAddLineToPoint(contextRef, 25, 50)
		CGContextAddLineToPoint(contextRef, rect.width - 25, 50)
		CGContextAddLineToPoint(contextRef, rect.width - 25, 0)
		CGContextClosePath(contextRef)
		CGContextFillPath(contextRef)
		
		// the tip
		CGContextMoveToPoint(contextRef, 30, 10 + circleRadius)
		CGContextAddLineToPoint(contextRef, rect.width / 2, rect.height - 21)
		CGContextAddLineToPoint(contextRef, rect.width - 30, 10 + circleRadius)
		CGContextClosePath(contextRef)
		CGContextFillPath(contextRef)
		
		// the +
		CGContextMoveToPoint(contextRef, rect.width / 2 - 10, rect.height - 20)
		CGContextAddLineToPoint(contextRef, rect.width / 2 - 1, rect.height - 20)
		CGContextMoveToPoint(contextRef, rect.width / 2 + 1, rect.height - 20)
		CGContextAddLineToPoint(contextRef, rect.width / 2 + 10, rect.height - 20)
		CGContextMoveToPoint(contextRef, rect.width / 2, rect.height - 19)
		CGContextAddLineToPoint(contextRef, rect.width / 2, rect.height - 10)
		CGContextStrokePath(contextRef)
		
		// white for the background
		CGContextAddEllipseInRect(contextRef, CGRect(x: 5, y: 5, width: 2 * circleRadius, height: 2 * circleRadius))
		CGContextSetFillColorWithColor(contextRef, UIColor.whiteColor().CGColor)
		CGContextFillPath(contextRef)
		
		// the actual color
		CGContextAddEllipseInRect(contextRef, CGRect(x: 5, y: 5, width: 2 * circleRadius, height: 2 * circleRadius))
		CGContextSetFillColorWithColor(contextRef, pixelColor.CGColor)
		CGContextFillPath(contextRef)
		
		// write the color elements
		var rgba = [CGFloat](count: 4, repeatedValue: 0.0)
		
		pixelColor.getRed(&rgba[0], green: &rgba[1], blue: &rgba[2], alpha: &rgba[3])
		
		let intVal = String(format: "R:%03.0f, G:%03.0f\nB:%03.0f, A:%03.0f", Float(rgba[0]) * 255.99999, Float(rgba[1]) * 255.99999, Float(rgba[2]) * 255.99999, Float(rgba[3]) * 255.99999)
		let hexVal = String(format: "#%02x%02x%02x%02x", Int(Float(rgba[3]) * 255.99999), Int(Float(rgba[0]) * 255.99999), Int(Float(rgba[1]) * 255.99999), Int(Float(rgba[2]) * 255.99999))
		
		
		let attribs = [NSForegroundColorAttributeName: fontColor, NSFontAttributeName: UIFont.boldSystemFontOfSize(10)]
		var text = NSAttributedString(string: intVal, attributes: attribs)
		text.drawAtPoint(CGPointMake(48, 7))
		text = NSAttributedString(string: hexVal, attributes: attribs)
		text.drawAtPoint(CGPointMake(48, 32))
	}
}