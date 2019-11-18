//
//  Button+Animation.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

extension Button
{
	func blink() {
		let originalBg = self.backgroundColor
		self.backgroundColor = .white
		UIView.animate(withDuration: 0.5,
					   delay: 0.0,
					   options: [.curveLinear],
					   animations: { self.backgroundColor = originalBg },
					   completion: nil
		)
	}

	func reverseColors() {
		let originalBg = self.backgroundColor
		let originalTitle = self.currentTitleColor
		UIView.animate(withDuration: 0.5,
					   delay: 0.0,
					   options: [.curveLinear],
					   animations: {
						self.backgroundColor = originalTitle
						self.setTitleColor(originalBg, for: .normal)
		},
					   completion: nil
		)
	}
}
