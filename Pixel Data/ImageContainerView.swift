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

class ImageContainerView: UIScrollView, UIScrollViewDelegate {
	let overlayViewsOffset = 40.0 as CGFloat
	
	var image: UIImage = UIImage.alloc()
	
	var imageView: UIImageView!
	var imageWidth: NSLayoutConstraint!
	var imageHeight: NSLayoutConstraint!
	
	var colorPinView: ColorPinView!
	var measurementView: MeasurementView!
	
	var mode = Mode.Freestyle
	
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
		measurementView = MeasurementView()
		self.addSubview(measurementView)
		
		colorPinView = ColorPinView()
		self.addSubview(colorPinView)
	}
	
	func setImage(image: UIImage) {
		maximumZoomScale = 1
		minimumZoomScale = 1
		zoomScale = 1
		
		self.image = image
		imageView.image = self.image
		imageWidth.constant = self.image.size.width
		imageHeight.constant = self.image.size.height
		imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
		//        self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)
		
		let widthRatio = ((self.frame.size.width-self.contentInset.left-self.contentInset.right)/self.imageView.frame.size.width)
		let heightRatio = ((self.frame.size.height-self.contentInset.top-self.contentInset.bottom)/self.imageView.frame.size.height)
		let minZoomScale = min(widthRatio, heightRatio)
		minimumZoomScale = minZoomScale
        maximumZoomScale = max(self.image.size.width * 10 / self.frame.size.width, minZoomScale * 10)
		setZoomScale(minZoomScale, animated: true)
	}
	
	//MARK: Measurement view
	
	func showMeasurementView(var #touch1Position: CGPoint, var touch2Position: CGPoint) {
		touch1Position.y -= overlayViewsOffset
		touch2Position.y -= overlayViewsOffset
		
		touch1Position.x = floor(touch1Position.x / zoomScale) * zoomScale
		touch1Position.y = floor(touch1Position.y / zoomScale) * zoomScale
		touch2Position.x = floor(touch2Position.x / zoomScale) * zoomScale
		touch2Position.y = floor(touch2Position.y / zoomScale) * zoomScale
		
		measurementView.setPoints(touch1Position, point2: touch2Position, zoomScale: zoomScale)
		measurementView.hidden = false
	}
	
	func hideMeasurementView() {
		measurementView.hidden = true
	}
	
	//MARK: Color pin
	
	func showColorPin(var touchPosition: CGPoint) {
		touchPosition.y -= overlayViewsOffset
		
		touchPosition.x = floor(touchPosition.x / zoomScale) * zoomScale
		touchPosition.y = floor(touchPosition.y / zoomScale) * zoomScale
		
		var pinLocation = touchPosition
		pinLocation.x -= colorPinView.frame.width / 2
		pinLocation.y -= colorPinView.frame.height - 20
		colorPinView.frame = CGRect(x: pinLocation.x, y: pinLocation.y, width: colorPinView.frame.width, height: colorPinView.frame.height)
		
		let positionInImage = CGPoint(x: floor(touchPosition.x / zoomScale), y: floor(touchPosition.y / zoomScale))
		colorPinView.color = colorAtPosition(positionInImage)
		
		colorPinView.hidden = false
	}
	
	func hideColorPin() {
		colorPinView.hidden = true
	}
	
	func colorAtPosition(positionInImage: CGPoint) -> UIColor {
		if(positionInImage.x < 0 || positionInImage.x > image.size.width
			|| positionInImage.y < 0 || positionInImage.y > image.size.height) {
				return UIColor.whiteColor()
		}
		
		let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
		let data = CFDataGetBytePtr(pixelData);
		
		let pixelInfo = Int(((image.size.width * positionInImage.y) + positionInImage.x) * 4); // The image is png
		
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
}