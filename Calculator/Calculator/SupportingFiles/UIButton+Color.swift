//
//  UIButton+Color.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 20.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

extension UIButton
{
	func setBackgroundColor(_ color: UIColor, for state: State) {
		self.clipsToBounds = true
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		if let context = UIGraphicsGetCurrentContext() {
			context.setFillColor(color.cgColor)
			context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
			let colorImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			self.setBackgroundImage(colorImage, for: state)
		}
	}

	func setImageTintColor(_ color: UIColor, for state: State) {
		var tintedImage: UIImage?
		if #available(iOS 13.0, *) {
			tintedImage = imageView?.image?.withTintColor(color)
		}
		else {
			tintedImage = imageView?.image?.withRenderingMode(.alwaysTemplate)
		}
		setImage(tintedImage, for: state)
		tintColor = color
	}
}
