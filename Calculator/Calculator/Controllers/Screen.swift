//
//  Screen.swift
//  Calculator
//
//  Created by MacBook Air on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class Screen: UIView
{

	var buttonsArray = [UIButton]()
	let symbolArray = ["0", ",", "=", "1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "×", "AC", "⁺∕₋", "%", "÷"]

	lazy var bottomStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [buttonsArray[0], buttonsArray[1], buttonsArray[2]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fillProportionally

		return stackView
	}()

	lazy var secondStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [buttonsArray[3], buttonsArray[4], buttonsArray[5], buttonsArray[6]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var thirdStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [buttonsArray[7], buttonsArray[8], buttonsArray[9], buttonsArray[10]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var fourthStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[buttonsArray[11], buttonsArray[12], buttonsArray[13], buttonsArray[14]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var fifthStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[buttonsArray[15], buttonsArray[16], buttonsArray[17], buttonsArray[18]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var allButtonsStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[fifthStackView, fourthStackView, thirdStackView, secondStackView, bottomStackView])
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	var windowLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.backgroundColor = .black
		label.textAlignment = .right
		label.textColor = .white
		label.font = UIFont(name: "FiraSans-Light", size: 94)
		label.text = "0"
		label.numberOfLines = 1
		return label
	}()

	init() {
		super.init(frame: .zero)
		backgroundColor = .black
		createArray()
		addSubview(windowLabel)
		addSubview(allButtonsStackView)
		makeConstraints()
		roundUpButtons()
		colorButton()
		setTitle()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func createArray() {
		for _ in 1...19 {
			let button = UIButton()
			buttonsArray.append(button)
			addSubview(button)
		}
	}

	func roundUpButtons() {
		for button in buttonsArray {
			button.layoutIfNeeded()
			button.layer.cornerRadius = button.bounds.height / 2
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
