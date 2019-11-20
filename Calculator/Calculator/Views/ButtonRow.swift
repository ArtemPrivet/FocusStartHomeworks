//
//  ButtonRow.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 18/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonRow: UIStackView
{
	private let countWidth = 4
//	let rowStack = UIStackView()

	init() {
		super.init(frame: .zero)
		setUpRowStack()
		translatesAutoresizingMaskIntoConstraints = false
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func setUpRowStack() {
		for _ in 0..<countWidth {
			let button = CalculatorButton()
			if button.identifier == 17 {
				button.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 2).isActive = true
			}
			if button.identifier == 20 {
				break
			}
			self.addArrangedSubview(button)
				self.distribution = .fillEqually
			}
		self.axis = .horizontal
		self.alignment = .fill
		self.spacing = 15
	}
}
