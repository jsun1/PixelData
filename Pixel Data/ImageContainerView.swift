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
		self.maximumZoomScale = minZoomScale * 6
		self.setZoomScale(minZoomScale, animated: true)
	}
	
//	func colorAtLocation(location: CGPoint) -> UIColor? {
//		let contentWidth = scrollView.contentSize.width
//		let imageWidth = image.size.width
//		
//		let positionInImage = (scrollView.zoomScale * (location.x * imageWidth / contentWidth))
//		
//		var color: UIColor?;
//		let inImage = image.CGImage;
//		// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
//		let contextRef = [self createARGBBitmapContextFromImage:inImage];
//		if (cgctx == NULL) { return nil; /* error */ }
//		
//		size_t w = CGImageGetWidth(inImage);
//		size_t h = CGImageGetHeight(inImage);
//		CGRect rect = {{0,0},{w,h}};
//		
//		// Draw the image to the bitmap context. Once we draw, the memory
//		// allocated for the context for rendering will then contain the
//		// raw image data in the specified color space.
//		CGContextDrawImage(cgctx, rect, inImage);
//		
//		// Now we can get a pointer to the image data associated with the bitmap
//		// context.
//		unsigned char* data = CGBitmapContextGetData (cgctx);
//		if (data != NULL) {
//			//offset locates the pixel in the data from x,y.
//			//4 for 4 bytes of data per pixel, w is width of one row of data.
//			int offset = 4*((w*round(point.y))+round(point.x));
//			int alpha =  data[offset];
//			int red = data[offset+1];
//			int green = data[offset+2];
//			int blue = data[offset+3];
//			NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
//			color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
//		}
//		
//		// When finished, release the context
//		CGContextRelease(cgctx);
//		// Free image data memory for the context
//		if (data) { free(data); }
//		
//		return color;
//	}
	
		
//		- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
//	
//	CGContextRef    context = NULL;
//	CGColorSpaceRef colorSpace;
//	void *          bitmapData;
//	int             bitmapByteCount;
//	int             bitmapBytesPerRow;
//	
//	// Get image width, height. We'll use the entire image.
//	size_t pixelsWide = CGImageGetWidth(inImage);
//	size_t pixelsHigh = CGImageGetHeight(inImage);
//	
//	// Declare the number of bytes per row. Each pixel in the bitmap in this
//	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
//	// alpha.
//	bitmapBytesPerRow   = (pixelsWide * 4);
//	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
//	
//	// Use the generic RGB color space.
//	colorSpace = CGColorSpaceCreateDeviceRGB();
//	
//	if (colorSpace == NULL)
//	{
//	fprintf(stderr, "Error allocating color space\n");
//	return NULL;
//	}
//	
//	// Allocate memory for image data. This is the destination in memory
//	// where any drawing to the bitmap context will be rendered.
//	bitmapData = malloc( bitmapByteCount );
//	if (bitmapData == NULL)
//	{
//	fprintf (stderr, "Memory not allocated!");
//	CGColorSpaceRelease( colorSpace );
//	return NULL;
//	}
//	
//	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
//	// per component. Regardless of what the source image format is
//	// (CMYK, Grayscale, and so on) it will be converted over to the format
//	// specified here by CGBitmapContextCreate.
//	context = CGBitmapContextCreate (bitmapData,
//	pixelsWide,
//	pixelsHigh,
//	8,      // bits per component
//	bitmapBytesPerRow,
//	colorSpace,
//	kCGImageAlphaPremultipliedFirst);
//	if (context == NULL)
//	{
//	free (bitmapData);
//	fprintf (stderr, "Context not created!");
//	}
//	
//	// Make sure and release colorspace before returning
//	CGColorSpaceRelease( colorSpace );
//	
//	return context;
//	}
}