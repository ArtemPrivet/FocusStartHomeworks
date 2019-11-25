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
	private enum ButtonType: String
	{
		case number
		case operation
		case symbolic
	}

	private let numberButtonSchema = ButtonSchema(hexBackgroundgColor: "#333333",
												  hexTitleColor: "#FFFFFF",
												  fontName: "FiraSans-Regular",
												  fontSize: 36,
												  hexAnimateBackgroundColor: "#AAAAAA")
	private let operationButtonSchema = ButtonSchema(hexBackgroundgColor: "#FF9500",
													 hexTitleColor: "#FFFFFF",
													 fontName: "FiraSans-Regular",
													 fontSize: 30,
													 hexAnimateBackgroundColor: "#f7cf7e",
													 hexToggleBackgroundColor: "#FFFFFF",
													 hexToggleTitleColor: "#FF9500")
	private let symbolicButtonSchema = ButtonSchema(hexBackgroundgColor: "#AFAFAF",
												  hexTitleColor: "#000000",
												  fontName: "FiraSans-Regular",
												  fontSize: 30,
												  hexAnimateBackgroundColor: "#ebebeb")

	private let buttonSchemas: [String: ButtonSchema]
	private let spaceBetweenButtons: CGFloat = 14

	init() {
		buttonSchemas = [
			"number": numberButtonSchema,
			"operation": operationButtonSchema,
			"symbolic": symbolicButtonSchema,
		]
	}
	//Создаем массив кнопок для калькулятора
	func createCalculatorButtons() -> [UIButton] {

		let buttonTitles = [
			"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "＝", "＋", "－", "✕", "÷", "AC", "+/-", "%",
		]
		let buttons = buttonTitles.map{ createButton(title: $0) }
		return buttons
	}
	//Создаем кнопку
	private func createButton(title: String) -> UIButton {
		let button = UIButton()
		if let schema = getButtonSchema(buttonTitle: title) {
			setButtonProperties(button: button,
								title: title,
								hexBackgroundColor: schema.hexBackgroundColor,
								hexTitleColor: schema.hexTitleColor,
								font: UIFont(name: schema.fontName, size: schema.fontSize))
		}
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
		if title == "÷" {
			button.titleLabel?.font = UIFont(name: "FiraSans-Light", size: 45)
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		setUpButtonAspectRatioConstraints(button)
	}
	//Устанавливаем констрейнты для соотношения размеров для кнопок
	private func setUpButtonAspectRatioConstraints(_ button: UIButton) {
		guard let title = button.titleLabel?.text else { return }
		if title == "0" {
			button.widthAnchor.constraint(equalTo: button.heightAnchor,
										  multiplier: 2,
										  constant: spaceBetweenButtons).isActive = true
		}
		else {
			button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
		}
	}
	//Устанавливаем выравнивание текста на кнопке 0
	func setUpTextAlignmentOnZeroButton(button: UIButton) {
		guard let title = button.titleLabel?.text, title == "0" else { return }
		button.contentHorizontalAlignment = .center
		button.titleEdgeInsets = UIEdgeInsets(top: 0,
											  left: 0,
											  bottom: 0,
											  right: button.bounds.height + spaceBetweenButtons)
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
										if let schema = self.getButtonSchema(buttonTitle: buttonTitle) {
											self.setButtonColor(button: button,
																backgroundColor: UIColor(hex: schema.hexBackgroundColor),
																titleColor: UIColor(hex: schema.hexTitleColor))
										}
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
		if let schema = getButtonSchema(buttonTitle: buttonTitle) {
			targetColor = UIColor(hex: schema.hexAnimateBackgroundColor)
			button.backgroundColor = targetColor
			UIView.transition(with: button, duration: 0.5, options: [.allowUserInteraction, .curveEaseIn], animations: {
				if "＋－÷✕".contains(buttonTitle) {
					if let toggleBackgroundColor = schema.hexToggleBackgroundColor,
						let toggleTitleColor = schema.hexToggleTitleColor {
						self.setButtonColor(button: button,
											backgroundColor: UIColor(hex: toggleBackgroundColor),
											titleColor: UIColor(hex: toggleTitleColor))
					}
				}
				else {
					self.setButtonColor(button: button, backgroundColor: previousBgColor)
				}
			}, completion: nil )
		}
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
	//Получить схему текущей кнопки
	private func getButtonSchema(buttonTitle: String) -> ButtonSchema? {
		return buttonSchemas[typeOfButton(buttonTitle: buttonTitle).rawValue]
	}
}
