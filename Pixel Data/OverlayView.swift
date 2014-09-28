//
//  OverlayView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/28/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

protocol OverlayViewDelegate {
	 func deleteOverlayView(overlayView: OverlayView)
}

class OverlayView: UIView {
	
	// TODO class variable?
	var traceColor = UIColor.blackColor()
	var fontColor = UIColor.whiteColor()
	
	let deleteView = DeleteView()
	
	var zoomScale: CGFloat = CGFloat()
	
	var editMode: Bool = false {
		didSet {
			deleteView.hidden = !editMode
		}
	}
	
	// TODO weak?
	var delegate: OverlayViewDelegate?
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initOverlayView()
	}
	
	override init() {
		super.init()
		initOverlayView()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initOverlayView()
	}
	
	func initOverlayView() {
		self.backgroundColor = UIColor.clearColor()
		
		addSubview(deleteView)
		deleteView.hidden = !editMode
		
		var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapRecognized:"))
		tapRecognizer.numberOfTapsRequired = 1;
		deleteView.addGestureRecognizer(tapRecognizer)
	}
	
	func setColors(#traceColor: UIColor, fontColor:UIColor) {
		self.traceColor = traceColor
		self.fontColor = fontColor
		setNeedsDisplay()
	}
	
	func tapRecognized(gesture : UITapGestureRecognizer) {
		if delegate != nil {
			delegate!.deleteOverlayView(self)
		}
	}
}
