//
//  ButtonExtension.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 24/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation
import UIKit

extension UIButton
{
	func faded() {
		let shade = CABasicAnimation(keyPath: "opacity")
		shade.duration = 0.3
		shade.fromValue = 1
		shade.toValue = 0.7
		shade.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		shade.autoreverses = true
		shade.repeatCount = 1
		layer.add(shade, forKey: nil)
	}
}
