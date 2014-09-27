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
	
	var color = UIColor.whiteColor().CGColor
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext();
		CGContextAddEllipseInRect(contextRef, rect);
		CGContextSetFillColor(contextRef, CGColorGetComponents(color));
		CGContextFillPath(contextRef);
	}
}