//
//  CalculatorDisplay.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 17/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorDisplay: UIView
{
	let display = UILabel()

	init() {
		super.init(frame: .zero)
		addSubview(display)
		translatesAutoresizingMaskIntoConstraints = false
	}
@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func setText(_ text: String) {
		display.text = text
		display.textColor = .black
	}
}
