//
//  ImageContainerView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/27/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class ImageContainerView: UIScrollView, UIScrollViewDelegate {
	var image: UIImage = UIImage.alloc()
	
	var imageView: UIImageView!
	var imageWidth: NSLayoutConstraint!
	var imageHeight: NSLayoutConstraint!
	
	var colorPinView: ColorPinView!
	
//	required init(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		self.delegate = self
//	}
	
	func setImage(image: UIImage) {
		self.maximumZoomScale = 1
		self.minimumZoomScale = 1
		self.zoomScale = 1
		
		self.image = image
		self.imageView.image = self.image
		self.imageWidth.constant = self.image.size.width
		self.imageHeight.constant = self.image.size.height
		self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
		//        self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)
		
		let widthRatio = ((self.frame.size.width-self.contentInset.left-self.contentInset.right)/self.imageView.frame.size.width)
		let heightRatio = ((self.frame.size.height-self.contentInset.top-self.contentInset.bottom)/self.imageView.frame.size.height)
		let minZoomScale = min(widthRatio, heightRatio)
		self.minimumZoomScale = minZoomScale
		self.maximumZoomScale = minZoomScale * 6
		self.setZoomScale(minZoomScale, animated: true)
	}
	
	
	//MARK: Color pin
	
	func showColorPin(touchPosition: CGPoint) {
		var pinLocation = touchPosition
		pinLocation.x -= colorPinView.width / 2
		pinLocation.y -= colorPinView.height
		colorPinView.frame = CGRect(x: pinLocation.x, y: pinLocation.y, width: colorPinView.frame.width, height: colorPinView.frame.height)
		
		let positionInImage = CGPoint(x: floor((touchPosition.x + contentOffset.x) / zoomScale), y: floor((touchPosition.y + contentOffset.y) / zoomScale))
		colorPinView.color = colorAtPosition(positionInImage).CGColor
		
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
}