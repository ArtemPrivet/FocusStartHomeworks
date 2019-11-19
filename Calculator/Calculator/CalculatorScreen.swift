//
//  CalculatorButtons.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 17/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorScreen: UIView
{
	private let countWidth = 4
	private let countHeight = 5
	private var count: Int {
		return countWidth * countHeight
	}

	let display = CalculatorDisplay()
	let buttonsStack = ButtonsStack()
//	let buttonRow = ButtonRow()

	init() {
		super.init(frame: .zero)
		addSubview(display)
		addSubview(buttonsStack)
		display.backgroundColor = .white
		makeConstraints()
		translatesAutoresizingMaskIntoConstraints = false
	}
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func makeConstraints() {
		translatesAutoresizingMaskIntoConstraints = false

		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				display.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
				display.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 79),
				display.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -17),
				display.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / 6),
				])
			NSLayoutConstraint.activate([
				buttonsStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
				buttonsStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 200),
				buttonsStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -17),
				buttonsStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15),
				])
		}
		else {
			NSLayoutConstraint.activate([
				display.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
				display.topAnchor.constraint(equalTo: self.topAnchor, constant: 99),
				display.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
				display.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / 6),
				])
			NSLayoutConstraint.activate([
				buttonsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
				buttonsStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 200),
				buttonsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
				buttonsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
				])
		}
	}
}
