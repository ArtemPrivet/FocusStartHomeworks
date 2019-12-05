//
//  UIImage+Extension.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 03.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

extension UIImage
{
	func alpha(_ value: CGFloat) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
