//
//  MeasurementView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/27/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class MeasurementView: OverlayView {
	// TODO class variable?
	private let externalBoundsX = 60.0 as CGFloat
	private let externalBoundsY = 20.0 as CGFloat
	
	// point1InImage is always the point with the smaller x value
	private var point1InImage: CGPoint?
	private var point2InImage: CGPoint?
	
	override var zoomScale: CGFloat {
		didSet {
			if point1InImage == nil || point2InImage == nil {
				return
			}
			
			jiggleRotationAngle = M_PI / (100 as Double * Double(zoomScale))
			
			let point1 = CGPoint(x: point1InImage!.x * zoomScale - contentOffset.x, y: point1InImage!.y * zoomScale - contentOffset.y)
			let point2 = CGPoint(x: point2InImage!.x * zoomScale - contentOffset.x, y: point2InImage!.y * zoomScale - contentOffset.y)
			
			let minX = min(point1.x, point2.x)
			let maxX = max(point1.x, point2.x)
			let minY = min(point1.y, point2.y)
			let maxY = max(point1.y, point2.y)
			
			let positionInSuperview = CGPoint(x: minX - externalBoundsX, y: minY - externalBoundsY)
			
			frame = CGRect(x: positionInSuperview.x,
							y: positionInSuperview.y,
							width: maxX - minX + 2 * externalBoundsX,
							height: maxY - minY + 2 * externalBoundsY)
			setNeedsDisplay()
		}
	}
	
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
		deleteView.frame = CGRect(x: externalBoundsX/2, y: 0, width: deleteView.frame.width, height: deleteView.frame.height)
        self.clipsToBounds = false
	}
	
	func setPoints(point1: CGPoint, point2: CGPoint, zoomScale: CGFloat, contentOffset: CGPoint) {
		self.contentOffset = contentOffset
		
		// point1InImage is always the point with smaller x value
		if point1.x < point2.x {
			self.point1InImage = CGPoint(x: floor(point1.x/zoomScale), y: floor(point1.y/zoomScale))
			self.point2InImage = CGPoint(x: floor(point2.x/zoomScale), y: floor(point2.y/zoomScale))
		} else {
			self.point1InImage = CGPoint(x: floor(point2.x/zoomScale), y: floor(point2.y/zoomScale))
			self.point2InImage = CGPoint(x: floor(point1.x/zoomScale), y: floor(point1.y/zoomScale))
		}
		
		self.zoomScale = zoomScale
	}
	
	override func drawRect(rect: CGRect) {
		if point1InImage == nil || point2InImage == nil {
			return
		}
		
		let contextRef = UIGraphicsGetCurrentContext()
		
		var point1, point2: CGPoint
		
		if point1InImage!.y < point2InImage!.y {
			/**   |
			*	-- ---------
			*	  |			|
			*	  |			|
			*	  |			|
			*	   --------- --
			*				|			*/
			
			point1 = CGPoint(x: externalBoundsX, y: externalBoundsY)
			point2 = CGPoint(x: rect.width - externalBoundsX, y: rect.height - externalBoundsY)
		} else {
			/**				|
			*	   --------- --
			*	  |			|
			*	  |			|
			*	  |			|
			*	-- ---------
			*	  |						*/
			
			point1 = CGPoint(x: rect.width - externalBoundsX, y: externalBoundsY)
			point2 = CGPoint(x: externalBoundsX, y: rect.height - externalBoundsY)
		}
        
		CGContextSetFillColorWithColor(contextRef, traceColor.CGColor)
		CGContextSetStrokeColorWithColor(contextRef, traceColor.CGColor)
		
		var lineWidth = 1 as CGFloat
		if zoomScale >= 10 {
			lineWidth = 3
		}
		CGContextSetLineWidth(contextRef, lineWidth)
		
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
		
		let textString = String(format:"Δx: %d Δy: %d", Int(abs(point1InImage!.x - point2InImage!.x)), Int(abs(point1InImage!.y - point2InImage!.y)))
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
        
        //text for each point
        //point1
        let textString1 = String(format:"(%d, %d)", Int(point1InImage!.x), Int(point1InImage!.y))
        var text1 = NSAttributedString(string: textString1, attributes: attribs)
        let textPos1 = CGPointMake(point1.x - text1.size().width/2, point1.y + 6)
        // circle 1
        CGContextAddEllipseInRect(contextRef, CGRect(x: textPos1.x - backgroundHeight / 2, y: textPos1.y - 1, width: backgroundHeight, height: backgroundHeight))
        CGContextFillPath(contextRef)
        // circle 2
        CGContextAddEllipseInRect(contextRef, CGRect(x: textPos1.x + text1.size().width - backgroundHeight / 2, y: textPos1.y - 1, width: backgroundHeight, height: backgroundHeight))
        CGContextFillPath(contextRef)
        // rectangle
        CGContextFillRect(contextRef, CGRectMake(textPos1.x, textPos1.y - 1, text1.size().width, backgroundHeight))
        
        //point2
        let textString2 = String(format:"(%d, %d)", Int(point2InImage!.x), Int(point2InImage!.y))
        var text2 = NSAttributedString(string: textString2, attributes: attribs)
        let textPos2 = CGPointMake(point2.x - text2.size().width/2, point2.y - 20)
        // circle 1
        CGContextAddEllipseInRect(contextRef, CGRect(x: textPos2.x - backgroundHeight / 2, y: textPos2.y - 1, width: backgroundHeight, height: backgroundHeight))
        CGContextFillPath(contextRef)
        // circle 2
        CGContextAddEllipseInRect(contextRef, CGRect(x: textPos2.x + text2.size().width - backgroundHeight / 2, y: textPos2.y - 1, width: backgroundHeight, height: backgroundHeight))
        CGContextFillPath(contextRef)
        // rectangle
        CGContextFillRect(contextRef, CGRectMake(textPos2.x, textPos2.y - 1, text2.size().width, backgroundHeight))
		
        
        
        text1.drawAtPoint(textPos1)
        text2.drawAtPoint(textPos2)
        
		text.drawAtPoint(textPosition)
       
	}
}
