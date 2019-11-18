//
//  CalculatorButtons.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 17/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorScreen: UIView
{
	private let countWidth = 4
	private let countHeight = 5
	private var count: Int {
		return countWidth * countHeight
	}

	private var buttons: [CalculatorButton] = []

	let display = CalculatorDisplay()

	init() {
		super.init(frame: .zero)
		addSubview(display)
		for i in 0..<countWidth {
			for j in 0..<countHeight {
				let button = CalculatorButton()

				if i == 0 {
					button.tintColor = .black
					button.backgroundColor = .lightGray
				} else {
					button.tintColor = .white
					button.backgroundColor = .darkGray
				}
				if j == 3 {
					button.tintColor = .white
					button.backgroundColor = .orange
				}
				switch (i, j) {
				case (0, 0): button.setText("AC")
				case (0, 1): button.setText("+/-")
				case (0, 2): button.setText("%")
				case (0, 3): button.setText("÷")
				case (1, 3): button.setText("×")
				case (2, 3): button.setText("-")
				case (3, 3): button.setText("+")
				case (1, 3): button.setText("=")
				case (4, 2): button.setText(",")
				case (1, 0): button.setText("7")
				case (1, 1): button.setText("8")
				case (1, 2): button.setText("9")
				case (2, 0): button.setText("4")
				case (2, 1): button.setText("5")
				case (2, 2): button.setText("6")
				case (3, 0): button.setText("1")
				case (3, 1): button.setText("2")
				case (3, 2): button.setText("3")
				case (4, 0): button.setText("0")
				case (4, 1): button.setText("0!")
				default: break
				}
				button.layer.cornerRadius = bounds.width / 4
				buttons.append(button)
				addSubview(button)
			}
		}
		display.backgroundColor = .white
	}
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		makeConstraints()
	}

	func makeConstraints() {
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				display.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
				display.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 79),
				display.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -17),
				display.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / 6),
				])
		}
		else {
			NSLayoutConstraint.activate([
				display.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
				display.topAnchor.constraint(equalTo: self.topAnchor, constant: 99),
				display.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
				display.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / 6),
				])
		}
		var buttonSide = CGFloat()
		if #available(iOS 11.0, *) {
			buttonSide = self.safeAreaLayoutGuide.layoutFrame.width / 4 - 6
		} else {
			buttonSide = self.frame.width / 4 - 6
		}
		let spacing: CGFloat = 3
		for i in 1...count {

			var leftConstraint = NSLayoutConstraint()
			var rightConstraint = NSLayoutConstraint()
			var topConstraint = NSLayoutConstraint()
			var bottomConstraint = NSLayoutConstraint()

			if #available(iOS 11.0, *) {
				leftConstraint = buttons[i].leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
																	 constant: spacing + (buttonSide + 2 * spacing) * ((i % 4) - 1))
				rightConstraint = buttons[i].trailingAnchor.constraint(equalTo:self.safeAreaLayoutGuide.trailingAnchor,
																	   constant: spacing + (buttonSide + 2 * spacing) * ((i % 4) - 1) + buttonSide)
			} else {
				leftConstraint = buttons[i].leadingAnchor.constraint(equalTo: self.leadingAnchor,
																	 constant: spacing + (buttonSide + 2 * spacing) * ((i % 4) - 1))
				rightConstraint = buttons[i].trailingAnchor.constraint(equalTo:self.trailingAnchor,
																	   constant: spacing + (buttonSide + 2 * spacing) * ((i % 4) - 1) + buttonSide)
			}
			topConstraint = buttons[i].topAnchor.constraint(equalTo: display.bottomAnchor, constant: spacing)
			bottomConstraint = buttons[i].topAnchor.constraint(equalTo: display.bottomAnchor, constant: spacing + buttonSide)

			NSLayoutConstraint.activate([
				leftConstraint,
				topConstraint,
				rightConstraint,
				bottomConstraint,
				])
		}
	}
}
