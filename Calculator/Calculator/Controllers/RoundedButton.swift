//
//  RoundedButton.swift
//  Calculator
//
//  Created by MacBook Air on 19.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

//swiftlint:disable all

import UIKit

final class RoundedButton: UIButton
{
	var buttonsArray = [UIButton]()
	let symbolArray = ["0", ",", "=", "1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "×", "AC", "⁺∕₋", "%", "÷"]

	init() {
		super.init(frame: .zero)
		createArray()
		colorButton()
		setTitle()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func createArray() {
		for item in 1...19 {
			let button = UIButton()
			button.tag = item
			button.showsTouchWhenHighlighted = true
			buttonsArray.append(button)
			addSubview(button)
		}
	}

	func colorButton() {
		for (index, button) in buttonsArray.enumerated() {
			switch index {
			case 0, 1, 3, 4, 5, 7, 8, 9, 11, 12, 13:
				button.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
				button.setTitleColor(.white, for: .normal)
				button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 36)
			case 2, 6, 10, 14, 18:
				button.backgroundColor = UIColor(red: 1, green: 0.584, blue: 0, alpha: 1)
				button.setTitleColor(.white, for: .normal)
				button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 50)
			case 15, 16, 17:
				button.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
				button.setTitleColor(.black, for: .normal)
				button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 36)
			default:
				break
			}
		}
	}

	func setTitle() {
		for (button, symbol) in zip(buttonsArray, symbolArray) {
			button.setTitle(symbol, for: .normal)
		}
	}
}

