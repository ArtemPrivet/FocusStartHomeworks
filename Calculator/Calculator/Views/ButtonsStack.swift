//
//  ButtonsStack.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 18/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonsStack: UIStackView
{
	private let countHeight = 5
	private var arrayOfRows = [ButtonRow]()

	init() {
		super.init(frame: .zero)
		setUpButtonStack()
		translatesAutoresizingMaskIntoConstraints = false
	}
	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setUpButtonStack() {
		for _ in 0..<countHeight {
			let row = ButtonRow()
			arrayOfRows.append(row)
			self.addArrangedSubview(row)
		}
		self.axis = .vertical
		self.distribution = .fillEqually
		self.alignment = .fill
		self.spacing = 15
	}
}
