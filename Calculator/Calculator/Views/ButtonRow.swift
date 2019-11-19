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
			button.backgroundColor = .green
			self.addArrangedSubview(button)
		}
		self.axis = .horizontal
		self.distribution = .fillEqually
		self.alignment = .fill
		self.spacing = 5
	}
}
