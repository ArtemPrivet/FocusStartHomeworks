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
	let button = Button()

	lazy var bottomStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonArray[0], button.buttonArray[1], button.buttonArray[2]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fillProportionally

		return stackView
	}()

	lazy var secondStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonArray[3], button.buttonArray[4], button.buttonArray[5], button.buttonArray[6]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var thirdStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonArray[7], button.buttonArray[8], button.buttonArray[9], button.buttonArray[10]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var fourthStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonArray[11], button.buttonArray[12], button.buttonArray[13], button.buttonArray[14]])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.distribution = .fill

		return stackView
	}()

	lazy var fifthStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews:
			[button.buttonArray[15], button.buttonArray[16], button.buttonArray[17], button.buttonArray[18]])
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
		label.adjustsFontSizeToFitWidth = true
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
		for button in button.buttonArray {
			button.layer.cornerRadius = button.bounds.height / 2
		}
	}
}
