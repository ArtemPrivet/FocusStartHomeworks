//
//  ImageViewGradient.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 04.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class ImageViewWithGradient: UIImageView
{
	let myGradientLayer: CAGradientLayer
	
	override init(frame: CGRect)
	{
		myGradientLayer = CAGradientLayer()
		super.init(frame: frame)
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		myGradientLayer = CAGradientLayer()
		super.init(coder: aDecoder)
		self.setup()
	}
	
	func setup()
	{
		myGradientLayer.startPoint = CGPoint(x: 0, y: 0)
		myGradientLayer.endPoint = CGPoint(x: 0, y: 1)
		let colors: [CGColor] = [
			UIColor.white.withAlphaComponent(0.4).cgColor,
			UIColor.white.withAlphaComponent(0.5).cgColor,
			UIColor.white.withAlphaComponent(0.7).cgColor,
			UIColor.white.withAlphaComponent(0.9).cgColor,
			UIColor.white.withAlphaComponent(1.0).cgColor,
		]
		
		myGradientLayer.colors = colors
		myGradientLayer.isOpaque = false
		self.layer.addSublayer(myGradientLayer)
	}
	
	override func layoutSubviews()
	{
		myGradientLayer.frame = self.layer.bounds
	}
}
