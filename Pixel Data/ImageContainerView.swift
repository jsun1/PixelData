//
//  ImageContainerView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/27/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

enum Mode {
	case Freestyle,	Annotation
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
	
	var colorPinView: ColorPinView!
	var measurementView: MeasurementView!
	
	var overlayViews = [OverlayView]()
	
	var editMode: Bool = false {
		didSet {
			for view in overlayViews {
				view.editMode = editMode
			}
			
			measurementView.editMode = editMode
			colorPinView.editMode = editMode
		}
	}
	
	var mode: Mode = Mode.Freestyle {
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
		measurementView = createMeasurementView()
		colorPinView = createColorPinView()
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
		self.addSubview(view)
		
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
		self.addSubview(view)
		
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
		
		measurementView.hidden = true
		colorPinView.hidden = true
	}
	
	func updateColors() {
		let traceColor = theme == .Dark ? UIColor.blackColor() : UIColor.whiteColor()
		let fontColor = theme == .Dark ? UIColor.whiteColor() : UIColor.blackColor()
		
		measurementView.setColors(traceColor: traceColor, fontColor: fontColor)
		colorPinView.setColors(traceColor: traceColor, fontColor: fontColor)
		
		for view in overlayViews {
			view.setColors(traceColor: traceColor, fontColor: fontColor)
		}
	}
	
	func redrawOverlays() {
		for view in overlayViews {
			view.zoomScale = zoomScale
		}
		
		(measurementView as OverlayView).zoomScale = zoomScale
		(colorPinView as OverlayView).zoomScale = zoomScale
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
        maximumZoomScale = max(self.image!.size.width * 10 / self.frame.size.width, minZoomScale * 10)
        if (!zoomIsMin) {
            setZoomScale(prevZoomScale, animated: true)
        } else {
            setZoomScale(minZoomScale, animated: true)
        }
    }
	
	//MARK: Measurement view
	
	func showMeasurementView(var #touch1Position: CGPoint, var touch2Position: CGPoint) {
		touch1Position.y -= overlayViewsOffset
		touch2Position.y -= overlayViewsOffset
		
		measurementView.setPoints(touch1Position, point2: touch2Position, zoomScale: zoomScale)
		measurementView.hidden = false
	}
	
	func endShowingMeasurementView() {
		switch mode {
		case .Freestyle:
			measurementView.hidden = true
			
		case .Annotation:
			overlayViews.append(measurementView)
			measurementView = createMeasurementView()
		}
	}
	
	//MARK: Color pin
	
	func showColorPin(var touchPosition: CGPoint) {
		touchPosition.y -= overlayViewsOffset
		
		colorPinView.setPoint(touchPosition, zoomScale: zoomScale)
		colorPinView.pixelColor = colorAtPosition(colorPinView.getPointInImage()!)
		
		colorPinView.hidden = false
	}
	
	func endShowingColorPin() {
		switch mode {
		case .Freestyle:
			colorPinView.hidden = true
			
		case .Annotation:
			overlayViews.append(colorPinView)
			colorPinView = createColorPinView()
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