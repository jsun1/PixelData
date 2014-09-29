//
//  ImageContainerView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/27/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

enum Mode {
	case Realtime, Annotation
}

enum Theme {
	case Dark, Light
}

class ImageContainerView: UIScrollView, OverlayViewDelegate {
	let overlayViewsOffset = 40.0 as CGFloat
	
	var image: UIImage?
	var imageData: UnsafePointer<UInt8>?
	
	var imageView: UIImageView!
	//var imageWidth: NSLayoutConstraint!
	//var imageHeight: NSLayoutConstraint!
	
	var colorPinView: ColorPinView?
	var measurementView: MeasurementView?
	
	var overlayViews = [OverlayView]()
	
	var editMode: Bool = false {
		didSet {
			for view in overlayViews {
				view.editMode = editMode
			}
			
			if measurementView != nil {
				measurementView!.editMode = editMode
			}
			
			if colorPinView != nil {
				colorPinView!.editMode = editMode
			}
		}
	}
	
	var mode: Mode = Mode.Realtime {
		didSet {
			clearWorkspace()
		}
	}
	
	var theme: Theme = Theme.Dark {
		didSet {
			updateColors()
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initImageContainer()
	}
	
	override init() {
		super.init()
		initImageContainer()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initImageContainer()
	}
	
	func initImageContainer() {
	}
	
	// TODO generic constructor?
//	func createSubview<T>() -> T {
//		let view = T()
//		self.addSubview(view)
//		return view
//	}
	
	func createMeasurementView() -> MeasurementView {
		let view = MeasurementView()
		view.hidden = true
		self.superview!.addSubview(view)
		
		// TODO remove when traceColor and fontColor are class variables
		let traceColor = theme == .Dark ? UIColor.blackColor() : UIColor.whiteColor()
		let fontColor = theme == .Dark ? UIColor.whiteColor() : UIColor.blackColor()
		view.setColors(traceColor: traceColor, fontColor: fontColor)
		
		view.delegate = self
		
		return view
	}
	
	func createColorPinView() -> ColorPinView {
		let view = ColorPinView()
		view.hidden = true
		self.superview!.addSubview(view)
		
		// TODO remove when traceColor and fontColor are class variables
		let traceColor = theme == .Dark ? UIColor.blackColor() : UIColor.whiteColor()
		let fontColor = theme == .Dark ? UIColor.whiteColor() : UIColor.blackColor()
		view.setColors(traceColor: traceColor, fontColor: fontColor)
		
		view.delegate = self
		
		return view
	}
	
	func clearWorkspace() {
		for view in overlayViews {
			view.removeFromSuperview()
		}
		overlayViews.removeAll(keepCapacity: false)
		
		if measurementView != nil {
			measurementView!.hidden = true
		}
		
		if colorPinView != nil {
			colorPinView!.hidden = true
		}
	}
	
	func updateColors() {
		let traceColor = theme == .Dark ? UIColor.blackColor() : UIColor.whiteColor()
		let fontColor = theme == .Dark ? UIColor.whiteColor() : UIColor.blackColor()
		
		if measurementView != nil {
			measurementView!.setColors(traceColor: traceColor, fontColor: fontColor)
		}
		
		if colorPinView != nil {
			colorPinView!.setColors(traceColor: traceColor, fontColor: fontColor)
		}
		
		for view in overlayViews {
			view.setColors(traceColor: traceColor, fontColor: fontColor)
		}
	}
	
	func redrawOverlays() {
		var offset = contentOffset
		offset.x -= frame.origin.x
		offset.y -= frame.origin.y
		
		for view in overlayViews {
			view.contentOffset = offset
			view.zoomScale = zoomScale
		}
		
		// TODO why?
		if measurementView != nil {
			let overlayView = measurementView! as OverlayView;
			overlayView.contentOffset = offset
			overlayView.zoomScale = zoomScale
		}
		
		if colorPinView != nil {
			let overlayView = colorPinView! as OverlayView;
			overlayView.contentOffset = offset
			overlayView.zoomScale = zoomScale
		}
	}
	
	func setImage(image: UIImage) {
		clearWorkspace()
		
		self.image = image
		imageView.image = self.image!

		reZoom()
	}
    
    func reZoom() {
        let zoomIsMin = self.minimumZoomScale == self.zoomScale;
        let prevZoomScale = self.zoomScale;
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        self.imageView.frame = CGRectMake(0, 0, self.image!.size.width, self.image!.size.height);
        let widthRatio = ((self.frame.size.width-self.contentInset.left-self.contentInset.right)/self.imageView.frame.size.width)
        let heightRatio = ((self.frame.size.height-self.contentInset.top-self.contentInset.bottom)/self.imageView.frame.size.height)
        let minZoomScale = min(widthRatio, heightRatio)
        minimumZoomScale = minZoomScale
        maximumZoomScale = max(self.image!.size.width * 20 / self.frame.size.width, minZoomScale * 10)
        if (!zoomIsMin) {
            setZoomScale(prevZoomScale, animated: true)
        } else {
            setZoomScale(minZoomScale, animated: true)
        }
    }
	
	//MARK: Measurement view
	
	func showMeasurementView(var #touch1Position: CGPoint, var touch2Position: CGPoint) {
		if measurementView == nil {
			measurementView = createMeasurementView()
		}
		
		touch1Position.y -= overlayViewsOffset
		touch2Position.y -= overlayViewsOffset
		
		var offset = contentOffset
		offset.x -= frame.origin.x
		offset.y -= frame.origin.y
		measurementView!.setPoints(touch1Position, point2: touch2Position, zoomScale: zoomScale, contentOffset: offset)
		measurementView!.hidden = false
		
		measurementView!.editMode = editMode
	}
	
	func endShowingMeasurementView() {
		switch mode {
		case .Realtime:
			measurementView!.hidden = true
			
		case .Annotation:
			overlayViews.append(measurementView!)
			measurementView = nil
		}
	}
	
	//MARK: Color pin
	
	func showColorPin(var touchPosition: CGPoint) {
		if colorPinView == nil {
			colorPinView = createColorPinView()
		}
		
		touchPosition.y -= overlayViewsOffset
		
		var offset = contentOffset
		offset.x -= frame.origin.x
		offset.y -= frame.origin.y
		colorPinView!.setPoint(touchPosition, zoomScale: zoomScale, contentOffset: offset)
		colorPinView!.pixelColor = colorAtPosition(colorPinView!.getPointInImage()!)
		
		colorPinView!.hidden = false
		
		colorPinView!.editMode = editMode
	}
	
	func endShowingColorPin() {
		switch mode {
		case .Realtime:
			colorPinView!.hidden = true
			
		case .Annotation:
			overlayViews.append(colorPinView!)
			colorPinView = nil
		}
	}
	
	func colorAtPosition(positionInImage: CGPoint) -> UIColor {
		if image == nil {
			return UIColor.whiteColor()
		}
		
		if(positionInImage.x < 0 || positionInImage.x > image!.size.width
			|| positionInImage.y < 0 || positionInImage.y > image!.size.height) {
				return UIColor.whiteColor()
		}
		
//		if imageData == nil {
//			let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image!.CGImage));
//			imageData = CFDataGetBytePtr(pixelData);
//		}
//		
//		let data = imageData!
		
		let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image!.CGImage));
		let data = CFDataGetBytePtr(pixelData);
		
		let pixelInfo = Int(((image!.size.width * positionInImage.y) + positionInImage.x) * 4); // The image is png
		
		let red = data[pixelInfo];
		let green = data[(pixelInfo + 1)];
		let blue = data[pixelInfo + 2];
		let alpha = data[pixelInfo + 3];

		return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
	}
	
	func doubleTapped(gesture : UITapGestureRecognizer) {
        if self.zoomScale <= self.minimumZoomScale {
            //Normalize current content size back to content scale of 1.0f
            var contentSize = CGSizeZero
            contentSize.width = self.contentSize.width / self.zoomScale
            contentSize.height = self.contentSize.height / self.zoomScale
            
            //translate the zoom point to relative to the content rect
            var zoomPoint = gesture.locationInView(gesture.view)
            zoomPoint.x = (zoomPoint.x / self.bounds.size.width) * contentSize.width
            zoomPoint.y = (zoomPoint.y / self.bounds.size.height) * contentSize.height
            
            //derive the size of the region to zoom to
            var zoomSize = CGSizeZero
            zoomSize.width = self.bounds.size.width / (self.minimumZoomScale * 4)
            zoomSize.height = self.bounds.size.height / (self.minimumZoomScale * 4)
            
            //offset the zoom rect so the actual zoom point is in the middle of the rectangle
            var zoomRect = CGRectZero
            zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0
            zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0
            zoomRect.size.width = zoomSize.width;
            zoomRect.size.height = zoomSize.height;
            
            //apply the resize
            self.zoomToRect(zoomRect, animated: true)
        } else {
            self.setZoomScale(self.minimumZoomScale, animated: true)
        }
    }
	
	// MARK OverlayViewDelegate
	
	func deleteOverlayView(overlayView: OverlayView) {
		for var i = 0; i < overlayViews.count; i++ {
			if overlayViews[i] == overlayView {
				overlayView.removeFromSuperview()
				overlayViews.removeAtIndex(i)
				return
			}
		}
		
		overlayView.hidden = true
	}
}