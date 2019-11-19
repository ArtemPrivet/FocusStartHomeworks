//
//  ButtonCreator.swift
//  Calculator
//
//  Created by Stanislav on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

struct ButtonCreator
{
	private enum ButtonType
	{
		case digit
		case operation
		case symbolic
	}
	//Создаем кнопку
	func createButton(title: String) -> UIButton {
		switch typeOfButton(buttonTitle: title) {
		case .digit:
			return createNumberButton(with: title)
		case .operation:
			return createOperatorButton(with: title)
		case .symbolic:
			return createSymbolButton(title: title)
		}
	}
	//Создаем цифровую кнопку
	private func createNumberButton(with title: String) -> UIButton {
		let button = UIButton(frame: .zero)
		setButtonProperties(button: button,
							title: title,
							hexBackgroundColor: "#333333",
							hexTitleColor: "#FFFFFF",
							font: UIFont(name: "FiraSans-Regular", size: 36))
		return button
	}

	//Создаем кнопку с оператором
	private func createOperatorButton(with title: String) -> UIButton {
		let button = UIButton(frame: .zero)
		var customFont = UIFont()

		if title == "÷" {
			if let font = UIFont(name: "FiraSans-Light", size: 40) {
				customFont = font
			}
		}
		else {
			customFont = UIFont.systemFont(ofSize: 27, weight: .bold)
		}
		setButtonProperties(button: button,
							title: title,
							hexBackgroundColor: "#FF9500",
							hexTitleColor: "#FFFFFF",
							font: customFont)
		return button
	}
	// Создаем символьную кнопку
	private func createSymbolButton(title: String) -> UIButton {
		let button = UIButton(frame: .zero)
		setButtonProperties(button: button,
							title: title,
							hexBackgroundColor: "#AFAFAF",
							hexTitleColor: "#000000",
							font: UIFont(name: "FiraSans-Regular", size: 30))
		return button
	}
	//Установка свойств для кнопки
	private func setButtonProperties(button: UIButton,
									 title: String,
									 hexBackgroundColor backgroundColor: String,
									 hexTitleColor titleColor: String,
									 font: UIFont?) {
		button.setTitle(title, for: .normal)
		button.backgroundColor = UIColor(hex: backgroundColor)
		button.setTitleColor(UIColor(hex: titleColor), for: .normal)
		button.titleLabel?.font = font
		button.translatesAutoresizingMaskIntoConstraints = false
		setUpButtonAspectRatioConstraints(button)
	}

	//Устанавливаем констрейнты для соотношения размеров для кнопок
	func setUpButtonAspectRatioConstraints(_ button: UIButton) {
		if let title = button.titleLabel?.text, title != "0" {
			NSLayoutConstraint.activate([
				button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1),
			])
		}
	}
	//Делаем кнопку круглой
	func makeButtonRound(button: UIButton) {
		button.layer.cornerRadius = button.bounds.height / 2
	}
//анимация нажатия кнопки
	func animateButton(button: UIButton) {
		if let title = button.titleLabel?.text, let previousColor = button.backgroundColor {
			var targetColor = UIColor.white
			switch typeOfButton(buttonTitle: title) {
			case .digit:
				targetColor = .gray
			case .operation:
				targetColor = UIColor(hex: "#f7cf7e")
			case .symbolic:
				targetColor = UIColor(hex: "#ebebeb")
			}
			UIView.animate(withDuration: 0.7) {
				button.backgroundColor = targetColor
				UIView.animate(withDuration: 0.7) {
					button.backgroundColor = previousColor
				}
			}
		}
	}
//Тип кнопки
	private func typeOfButton(buttonTitle: String) -> ButtonType {
		if "0123456789,".contains(buttonTitle) {
			return ButtonType.digit
		}
		else if "＋－＝÷✕".contains(buttonTitle) {
			return ButtonType.operation
		}
		else {
			return ButtonType.symbolic
		}
	}
}
