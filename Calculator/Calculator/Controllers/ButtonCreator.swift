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
		case number
		case operation
		case symbolic
	}

//	private let numberButtonScheme: [(hexBackgroundColor: String,
//		hexTitleColor: String,
//		fontName: String,
//		fontSize: Int)] =
//		[
//			("#333333", "#FFFFFF", "FiraSans-Regular", 36),
//			("#FF9500", "#FFFFFF", "FiraSans-Regular", 36),
//			("#AFAFAF", "#000000", "FiraSans-Regular", 30),
//	]
	//Создаем массив кнопок для калькулятора
	func createCalculatorButtons() -> [UIButton] {
		let buttonTitles = [
			"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "＝", "＋", "－", "✕", "÷", "AC", "+/-", "%",
		]
		var buttons: [UIButton] = []
		buttonTitles.forEach{ buttons.append( createButton(title: $0)) }
		return buttons
	}
	//Создаем кнопку
	private func createButton(title: String) -> UIButton {
		switch typeOfButton(buttonTitle: title) {
		case .number:
			return createNumberButton(with: title)
		case .operation:
			return createOperatorButton(with: title)
		case .symbolic:
			return createSymbolButton(title: title)
		}
	}
	//Создаем цифровую кнопку
	private func createNumberButton(with title: String) -> UIButton {
		let button = UIButton()
		setButtonProperties(button: button,
							title: title,
							hexBackgroundColor: "#333333",
							hexTitleColor: "#FFFFFF",
							font: UIFont(name: "FiraSans-Regular", size: 36))
		return button
	}

	//Создаем кнопку с оператором
	private func createOperatorButton(with title: String) -> UIButton {
		let button = UIButton()
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
		let button = UIButton()
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
		setButtonColor(button: button, backgroundColor: UIColor(hex: backgroundColor), titleColor: UIColor(hex: titleColor))
		button.titleLabel?.font = font
		button.translatesAutoresizingMaskIntoConstraints = false
		setUpButtonAspectRatioConstraints(button)
	}

	//Устанавливаем констрейнты для соотношения размеров для кнопок
	private func setUpButtonAspectRatioConstraints(_ button: UIButton) {
		guard let title = button.titleLabel?.text, title != "0" else { return }
		button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
	}
	//Делаем кнопку круглой
	func makeButtonRound(button: UIButton) {
		button.layer.cornerRadius = button.bounds.height / 2
	}
	//Сброс цвета кнопки и шрифта для кнопок операций
	func resetColorSettingsForOperationButton(buttons: [UIButton]) {
		buttons.forEach {
			let button = $0
			if let buttonTitle = button.titleLabel?.text {
				if "＋－÷✕".contains(buttonTitle) {
					UIView.transition(with: button, duration: 0.5, options: [.allowUserInteraction, .curveEaseIn],
									  animations: {
										self.setButtonColor(button: button,
															backgroundColor: UIColor(hex: "#FF9500"),
															titleColor: UIColor(hex: "#FFFFFF"))
									  },
									  completion: nil )
				}
			}
		}
	}
	//Анимация нажатия
	func animateButtonTap(button: UIButton) {
		guard let buttonTitle = button.titleLabel?.text else { return }
		guard let previousBgColor = button.backgroundColor else { return }

		var targetColor = UIColor.gray
		switch typeOfButton(buttonTitle: buttonTitle) {
		case .number:
		  targetColor = .gray
		case .operation:
		  targetColor = UIColor(hex: "#f7cf7e")
		case .symbolic:
		  targetColor = UIColor(hex: "#ebebeb")
		}
		button.backgroundColor = targetColor
		UIView.transition(with: button, duration: 0.5, options: [.allowUserInteraction, .curveEaseIn], animations: {
			if "＋－÷✕".contains(buttonTitle) {
				self.setButtonColor(button: button, backgroundColor: UIColor(hex: "#FFFFFF"), titleColor: UIColor(hex: "#FF9500"))
			}
			else {
				self.setButtonColor(button: button, backgroundColor: previousBgColor)
			}
		}, completion: nil )
	}
	//Тип кнопки
	private func typeOfButton(buttonTitle: String) -> ButtonType {
		if "0123456789,".contains(buttonTitle) {
			return ButtonType.number
		}
		else if "＋－＝÷✕".contains(buttonTitle) {
			return ButtonType.operation
		}
		else {
			return ButtonType.symbolic
		}
	}
	//Настраиваем цветовую схему для кнопки
	private func setButtonColor(button: UIButton, backgroundColor: UIColor, titleColor: UIColor? = nil) {
		button.backgroundColor = backgroundColor
		if let titleColor = titleColor {
			button.setTitleColor(titleColor, for: .normal)
		}
	}
}
