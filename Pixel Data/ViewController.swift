//
//  ViewController.swift
//  Pixel Data
//
//  Created by Jeffrey Sun on 9/25/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIDocumentInteractionControllerDelegate, UIPopoverControllerDelegate {
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageContainerView: ImageContainerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topRuler: RulerView!
    @IBOutlet weak var sideRuler: RulerView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var editButton: UIButton!
	
	
	@IBOutlet weak var darkThemeButton: UIButton!
	@IBOutlet weak var lightThemeButton: UIButton!
	
	@IBOutlet weak var realtimeModeButton: UIButton!
	@IBOutlet weak var annotationModeButton: UIButton!
	
	var editingMode: Bool = false {
		didSet {
			editButton.selected = editingMode;
			
			imageContainerView.editMode = editingMode
		}
	}
    
    var popover:UIPopoverController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		imageContainerView.imageView = imageView
		
		imageContainerView.delegate = self
        
        self.imageView.layer.magnificationFilter = kCAFilterNearest
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            self.cameraPressed(self.cameraButton)
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if (self.gridView.hasImage) {
            self.imageContainerView.reZoom()
        }
    }
    
    
    //MARK: Delegates
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.popover!.dismissPopoverAnimated(true)
        picker.dismissViewControllerAnimated(true, completion: nil)
		self.imageContainerView.setImage(image)
		
		self.topRuler.hasImage = true
		self.sideRuler.hasImage = true
        self.gridView.hasImage = true
        self.gridView.size = image.size
    }
	
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        self.popover = nil
    }
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.topRuler.zoomScale = scrollView.zoomScale
        self.sideRuler.zoomScale = scrollView.zoomScale
        self.gridView.zoomScale = scrollView.zoomScale
        self.topRuler.offset = scrollView.contentOffset
        self.sideRuler.offset = scrollView.contentOffset
        self.gridView.offset = scrollView.contentOffset
		imageContainerView.redrawOverlays()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.topRuler.zoomScale = scrollView.zoomScale
        self.sideRuler.zoomScale = scrollView.zoomScale
        self.gridView.zoomScale = scrollView.zoomScale
        self.topRuler.offset = scrollView.contentOffset
        self.sideRuler.offset = scrollView.contentOffset
		self.gridView.offset = scrollView.contentOffset
		imageContainerView.redrawOverlays()
    }
    
    //MARK: IBActions

    @IBAction func cameraPressed(sender: UIBarButtonItem?) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.allowsEditing = false
        if (UIDevice.currentDevice().userInterfaceIdiom != .Pad) {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            if ((self.popover) != nil) {
                if (self.popover!.popoverVisible) {
                    self.popover!.dismissPopoverAnimated(true)
                    self.popover = nil;
                    return;
                }
                self.popover = nil;
            }
            var newPopover = UIPopoverController(contentViewController: imagePicker)
            newPopover.delegate = self;
            self.popover = newPopover;
            self.popover!.presentPopoverFromBarButtonItem(sender!, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    

    @IBAction func sharePressed(sender: UIBarButtonItem) {
        // Returns screen dimensions for the device
        //let screenDimensions: CGSize  = UIScreen.mainScreen().applicationFrame.size
        //println(screenDimensions)
        
        let layer = UIApplication.sharedApplication().keyWindow.layer
        let scale = UIScreen.mainScreen().scale
        
        //layer.frame.size.height -= (self.navigationController?.navigationBar.frame.size.height)!
        //layer.frame.size.height -= toolBar.frame.size.height
//        println(self.navigationController?.navigationBar.frame.size.height)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(layer.frame.size.width, self.topRuler.frame.size.height + self.imageContainerView.frame.size.height), false, scale)
        
        var context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, -self.topRuler.frame.origin.y)
        layer.renderInContext(context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //save in Photo Album for testing
        //UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        
        
        
        // Share the screenshot
        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        // Exclude few sharing options
        activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList,
            UIActivityTypePostToVimeo
        ]
        if (UIDevice.currentDevice().userInterfaceIdiom != .Pad) {
            self.navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
        } else {
            if ((self.popover) != nil) {
                if (self.popover!.popoverVisible) {
                    self.popover!.dismissPopoverAnimated(true)
                    self.popover = nil;
                    return;
                }
                self.popover = nil;
            }
            var newPopover = UIPopoverController(contentViewController: activityViewController)
            newPopover.delegate = self;
            self.popover = newPopover;
            self.popover!.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

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
	
	@IBAction func themeButtonTouched(sender: UIButton) {
		sender.selected = true
		if sender == darkThemeButton {
			lightThemeButton.selected = false
			imageContainerView.theme = Theme.Dark
		} else {
			darkThemeButton.selected = false
			imageContainerView.theme = Theme.Light
		}
	}
	
	
	@IBAction func modeButtonTouched(sender: UIButton) {
		sender.selected = true
		
		if sender == realtimeModeButton {
			annotationModeButton.selected = false
			
			if imageContainerView.mode == Mode.Annotation {
				imageContainerView.mode = Mode.Realtime
			}
		} else if sender == annotationModeButton {
			realtimeModeButton.selected = false
			
			if imageContainerView.mode == Mode.Realtime {
				imageContainerView.mode = Mode.Annotation
			}
		}
		
		editingMode = false
	}
	
	@IBAction func editModeButtonTouched(sender: UIButton) {
		if imageContainerView.image == nil {
			return;
		}
		
		editingMode = !editingMode;
		
		sender.selected = editingMode
	}
}

