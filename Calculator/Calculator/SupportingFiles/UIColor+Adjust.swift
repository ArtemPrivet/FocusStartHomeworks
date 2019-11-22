//
//  UIColor+Adjust.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 20.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

extension UIColor
{

	func lighter(by percentage: CGFloat = 20.0) -> UIColor? {
		self.adjust(by: abs(percentage) )
	}

	func darker(by percentage: CGFloat = 20.0) -> UIColor? {
		self.adjust(by: -1 * abs(percentage) )
	}

	func adjust(by percentage: CGFloat = 20.0) -> UIColor? {
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
		guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
			return nil
		}
		return UIColor(red: min(red + percentage / 100, 1.0),
					   green: min(green + percentage / 100, 1.0),
					   blue: min(blue + percentage / 100, 1.0),
					   alpha: alpha)
	}
}
