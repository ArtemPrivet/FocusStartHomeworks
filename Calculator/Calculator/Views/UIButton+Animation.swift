//
//  UIButton+Animation.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

extension UIButton
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
}
