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
	let button = RoundedButton()

	lazy var bottomStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonsArray[0], button.buttonsArray[1], button.buttonsArray[2]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fillProportionally

		return stackView
	}()

	lazy var secondStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonsArray[3], button.buttonsArray[4], button.buttonsArray[5], button.buttonsArray[6]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var thirdStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonsArray[7], button.buttonsArray[8], button.buttonsArray[9], button.buttonsArray[10]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var fourthStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonsArray[11], button.buttonsArray[12], button.buttonsArray[13], button.buttonsArray[14]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var fifthStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonsArray[15], button.buttonsArray[16], button.buttonsArray[17], button.buttonsArray[18]])
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
		addSubview(windowLabel)
		addSubview(allButtonsStackView)
		makeConstraints()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		for button in button.buttonsArray {
			button.layer.cornerRadius = button.bounds.height / 2
		}
	}
}
