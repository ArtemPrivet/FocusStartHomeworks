//
//  ButtonRow.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 18/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonRow: UIView
{
	private let countWidth = 4
	private var rowOfButton = [CalculatorButton]()
	private let button = CalculatorButton()

	init() {
		super.init(frame: .zero)
		for _ in 0..<countWidth {
		button.backgroundColor = .green
			rowOfButton.append(button)
		}
		let rowStack = UIStackView(arrangedSubviews: rowOfButton)
		rowStack.axis = .horizontal
		rowStack.distribution = .fill
		rowStack.alignment = .fill
		rowStack.spacing = 5
		addSubview(rowStack)
		translatesAutoresizingMaskIntoConstraints = false
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}
}
