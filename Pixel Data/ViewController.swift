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
		
		self.topRuler.hasImage = true
		self.sideRuler.hasImage = true
    }
	
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.topRuler.zoomScale = scrollView.zoomScale
        self.sideRuler.zoomScale = scrollView.zoomScale
        self.topRuler.offset = scrollView.contentOffset
        self.sideRuler.offset = scrollView.contentOffset
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.topRuler.zoomScale = scrollView.zoomScale
        self.sideRuler.zoomScale = scrollView.zoomScale
        self.topRuler.offset = scrollView.contentOffset
        self.sideRuler.offset = scrollView.contentOffset
		
		imageContainerView.redrawOverlays()
    }
    
    //MARK: IBActions

    @IBAction func cameraPressed(sender: UIBarButtonItem?) {
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
        
//        var dic = UIDocumentInteractionController(URL: imageURL)
//        dic.delegate = self;
//        dic .presentOptionsMenuFromBarButtonItem(sender, animated: true)
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
        self.navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
    

    }
	
	@IBAction func longPressRecognized(sender: UILongPressGestureRecognizer) {
		if imageContainerView.image == nil {
			return;
		}
		
		if(sender.state == .Began) {
			imageContainerView.showColorPin(sender.locationInView(imageContainerView))
		} else if(sender.state == .Changed) {
			imageContainerView.showColorPin(sender.locationInView(imageContainerView))
		} else if(sender.state == .Ended) {
			imageContainerView.endShowingColorPin()
		}
	}
	
	@IBAction func longPress2FingersRecognized(sender: UILongPressGestureRecognizer) {
		if imageContainerView.image == nil {
			return;
		}
		
		if(sender.state == .Began) {
			imageContainerView.showMeasurementView(touch1Position: sender.locationOfTouch(0, inView: imageContainerView), touch2Position: sender.locationOfTouch(1, inView: imageContainerView))
		} else if(sender.state == .Changed) {
			imageContainerView.showMeasurementView(touch1Position: sender.locationOfTouch(0, inView: imageContainerView), touch2Position: sender.locationOfTouch(1, inView: imageContainerView))
		} else if(sender.state == .Ended) {
			imageContainerView.endShowingMeasurementView()
		}
	}
	
	@IBAction func doubleTapOnImageContainerRecognized(sender: UITapGestureRecognizer) {
		if imageContainerView.image == nil {
			cameraPressed(nil)
		} else {
			imageContainerView.doubleTapped(sender)
		}
	}
	
	@IBAction func themeChanged(sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			imageContainerView.theme = Theme.Dark
		} else {
			imageContainerView.theme = Theme.Light
		}
	}
	
	@IBAction func modeChanged(sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			imageContainerView.mode = Mode.Freestyle
		} else {
			imageContainerView.mode = Mode.Annotation
		}
	}
	
	@IBAction func toggleEditMode(sender: UIBarButtonItem) {
		if sender.style == .Done {
			sender.style = .Plain
			imageContainerView.editMode = false
		} else {
			sender.style = .Done
			imageContainerView.editMode = true
		}
	}
}

