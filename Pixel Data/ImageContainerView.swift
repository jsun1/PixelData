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
        self.maximumZoomScale = max(self.image.size.width * 10 / self.frame.size.width, minZoomScale * 10)
		self.setZoomScale(minZoomScale, animated: true)
	}
	
	
	func colorAtPosition(position: CGPoint) -> UIColor {
		
		let contentOffset = self.contentOffset
		let imageSize = image.size
		let zoomScale = self.zoomScale
		
		print("Offset: ")
		println(self.contentOffset)
		print("Image size: ")
		println(image.size)
		print("Zoom scale: ")
		println(self.zoomScale)
		print("Frame size: ")
		println(self.frame.size)
		print("Position: ")
		println(position)
		println()
		
		let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
		let data = CFDataGetBytePtr(pixelData);
		
		let pixelInfo = Int(((image.size.width * position.y) + position.x) * 4); // The image is png
		
		let red = data[pixelInfo];
		let green = data[(pixelInfo + 1)];
		let blue = data[pixelInfo + 2];
		let alpha = data[pixelInfo + 3];

		return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
	}
}