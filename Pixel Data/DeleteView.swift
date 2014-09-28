//
//  DeleteView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/28/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class DeleteView: UIView {
	private let size = 20.0 as CGFloat
	
	// TODO class variable?
	private var traceColor = UIColor.grayColor()
	private var fontColor = UIColor.whiteColor()
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initDeleteView()
	}
	
	override init() {
		super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
		initDeleteView()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initDeleteView()
	}
	
	func initDeleteView() {
		backgroundColor = UIColor.clearColor()
	}
	
	func setColors(#traceColor: UIColor, fontColor:UIColor) {
		self.traceColor = traceColor
		self.fontColor = fontColor
		setNeedsDisplay()
	}
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(contextRef, traceColor.CGColor)
		
		CGContextAddEllipseInRect(contextRef, CGRect(x: 0, y: 0, width: size, height: size))
		CGContextFillPath(contextRef)
	}
}
