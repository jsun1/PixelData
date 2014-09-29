//
//  DeleteView.swift
//  Pixel Data
//
//  Created by Bruno Nunes on 9/28/14.
//  Copyright (c) 2014 Jeffrey Sun. All rights reserved.
//

import UIKit

class DeleteView: UIImageView {
	private let size = 20.0 as CGFloat
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initDeleteView()
	}
	
	override init() {
		super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
		initDeleteView()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initDeleteView()
	}
	
	func initDeleteView() {
		image = UIImage(named: "delete_icon")
		userInteractionEnabled = true
	}
}
