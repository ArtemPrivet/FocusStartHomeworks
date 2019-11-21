//
//  UIButton+Extensions.swift
//  Calculator
//
//  Created by Иван Медведев on 20/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

extension UIButton
{
	//swiftlint:disable:next override_in_extension
	open override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ?
				self.backgroundColor?.withAlphaComponent(0.5) : backgroundColor?.withAlphaComponent(1.0)
		}
	}
}
