//
//  ViewController.swift
//  Pixel Data
//
//  Created by Jeffrey Sun on 9/25/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIDocumentInteractionControllerDelegate {
	
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageContainerView: ImageContainerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var topRuler: RulerView!
    @IBOutlet weak var sideRuler: RulerView!
    
	@IBOutlet weak var colorPinView: ColorPinView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		imageContainerView.imageView = imageView
		imageContainerView.imageWidth = imageWidth
		imageContainerView.imageHeight = imageHeight
		
		imageContainerView.delegate = self
    }

    //MARK: Delegates
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        picker.dismissViewControllerAnimated(true, completion: nil)
		imageContainerView.setImage(image)
		
		//        self.topRuler.zoomScale = self.scrollView.zoomScale
		//        self.sideRuler.zoomScale = self.scrollView.zoomScale
		self.topRuler.hasImage = true
		self.sideRuler.hasImage = true
    }
	
	
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.topRuler.zoomScale = scrollView.zoomScale
        self.sideRuler.zoomScale = scrollView.zoomScale
        self.topRuler.setNeedsDisplay()
        self.sideRuler.setNeedsDisplay()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.topRuler.zoomScale = scrollView.zoomScale
        self.sideRuler.zoomScale = scrollView.zoomScale
        self.topRuler.setNeedsDisplay()
        self.sideRuler.setNeedsDisplay()
    }
    
    
    //MARK: IBActions

    @IBAction func cameraPressed(sender: UIBarButtonItem) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func sharePressed(sender: UIBarButtonItem) {
        let imagePath: NSString = NSHomeDirectory().stringByAppendingPathComponent("screenshot.jpg")
        UIImageJPEGRepresentation(imageContainerView.image, 0.95)
        let imageURL: NSURL = NSURL(string: NSString(format: "file://%@", imagePath))
        
        var dic = UIDocumentInteractionController(URL: imageURL)
        dic.delegate = self;
        dic .presentOptionsMenuFromBarButtonItem(sender, animated: true)
        
//        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
//        self.navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
    

    }
	
	func updateColorPinLocation(touchPosition: CGPoint) {
		var pinLocation = touchPosition
		pinLocation.x -= colorPinView.width / 2
		pinLocation.y -= colorPinView.height
		colorPinView.frame = CGRect(x: pinLocation.x, y: pinLocation.y, width: colorPinView.frame.width, height: colorPinView.frame.height)
	}
	
	@IBAction func longPressureRecognized(sender: UILongPressGestureRecognizer) {
		if imageContainerView.image.size.width == 0 {
			return;
		}
		
		if(sender.state == .Began) {
			colorPinView.color = imageContainerView.colorAtPosition(sender.locationInView(view)).CGColor
			
			updateColorPinLocation(sender.locationInView(view))
			
			colorPinView.hidden = false
		} else if(sender.state == .Changed) {
			colorPinView.color = imageContainerView.colorAtPosition(sender.locationInView(view)).CGColor
			
			updateColorPinLocation(sender.locationInView(view))
		} else if(sender.state == .Ended) {
			colorPinView.hidden = true
		}
	}
	

}

