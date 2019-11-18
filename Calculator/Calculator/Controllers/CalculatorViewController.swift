//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//
//
import UIKit

final class CalculatorViewController: UIViewController
{
	private var buttons: [UIButton] = []
	private var resultLabel = UILabel()

	private var isTyping = false

	private var displayValue: Double? {
		get {
			if let text = resultLabel.text {
				return Double(text.replacingOccurrences(of: ",", with: "."))
			}
			else {
				return 0
			}
		}
		set {
			if let value: Double = newValue {
				resultLabel.text = ((value.truncatingRemainder(dividingBy: 1) == 0) ?
					String(format: "%0.f", value) : String(value)).replacingOccurrences(of: ".", with: ",")
			}
			else {
				resultLabel.text = nil
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = UIColor(hex: "#000000")
		createControls()
	}

	private func createControls() {
//Создаем массив кнопок
		createButtons()
		guard buttons.count == 19 else { fatalError("Wrong number of buttons") }
//Складываем кнопки в стэки
		let firstStackView = UIStackView(arrangedSubviews: [buttons[0], buttons[1], buttons[2]])
		let secondStackView = UIStackView(arrangedSubviews: [buttons[3], buttons[4], buttons[5], buttons[6]])
		let thirdStackView = UIStackView(arrangedSubviews: [buttons[7], buttons[8], buttons[9], buttons[10]])
		let fourthStackView = UIStackView(arrangedSubviews: [buttons[11], buttons[12], buttons[13], buttons[14]])
		let fifthStackView = UIStackView(arrangedSubviews: [buttons[15], buttons[16], buttons[17], buttons[18]])

		let arrayOfHorizontalStacks = [fifthStackView, fourthStackView, thirdStackView, secondStackView, firstStackView]
//устанавливаем свойства по умолчанию для горизонтальных стэков
		arrayOfHorizontalStacks.forEach{ setUpHorizontalStackView(stackView: $0) }

		let mainStackView = UIStackView(arrangedSubviews: arrayOfHorizontalStacks)
//устанавливаем свойства по умолчанию для вертикального стэка
		setUpVerticalStackView(stackView: mainStackView)

		self.view.addSubview(mainStackView)
//Устанавливаем констрейнты для горизонтальных стэков
		arrayOfHorizontalStacks.forEach{ setHorizontalStackConstraints(stackView: $0, parentStackView: mainStackView) }
//Устанавливаем констрейнты для вертикального стэка
		setVerticalStackConstraints(stackView: mainStackView, parentView: self.view)
//Устанавливаем соотношения сторон для кнопок
		buttons.forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
		buttons.forEach{ setUpButtonAspectRatioConstraints($0) }
//Настраиваем констрейнты для нижней строки
		NSLayoutConstraint.activate([
			buttons[0].widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.5, constant: -7),
			buttons[1].widthAnchor.constraint(equalTo: buttons[2].widthAnchor),
		])
//Закругляем все кнопки
		buttons.forEach{ makeButtonRound(button: $0) }
//Выравниваем текст на кнопке "0" по левому краю
		buttons[0].contentHorizontalAlignment = .left
		buttons[0].titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
//		buttons.forEach{ $0.addTarget(self, action: #selector(clickButton), for: .touchUpInside) }
		setUpResultLabel(label: resultLabel)
		self.view.addSubview(resultLabel)
//Настраиваем констрейнты для лейбла
		NSLayoutConstraint.activate([
			resultLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
			resultLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17),
			resultLabel.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -8),
		])
	}

	private func createButtons() {
		buttons.append(createNumberButton(title: "0"))
		buttons.append(createNumberButton(title: ","))
		buttons.append(createOperatorButton(title: "="))

		buttons.append(createNumberButton(title: "1"))
		buttons.append(createNumberButton(title: "2"))
		buttons.append(createNumberButton(title: "3"))
		buttons.append(createOperatorButton(title: "+"))

		buttons.append(createNumberButton(title: "4"))
		buttons.append(createNumberButton(title: "5"))
		buttons.append(createNumberButton(title: "6"))
		buttons.append(createOperatorButton(title: "-"))

		buttons.append(createNumberButton(title: "7"))
		buttons.append(createNumberButton(title: "8"))
		buttons.append(createNumberButton(title: "9"))
		buttons.append(createOperatorButton(title: "×"))

		buttons.append(createSymbolButton(title: "AC"))
		buttons.append(createSymbolButton(title: "+/-"))
		buttons.append(createSymbolButton(title: "%"))
		buttons.append(createOperatorButton(title: "÷"))
	}
// MARK: - Обработка нажатий

	@objc private func clickNumberButton(_ sender: UIButton) {
		if let buttonTitle = sender.titleLabel?.text, let displayedText = resultLabel.text {
			if isTyping {
				if buttonTitle != "," || (buttonTitle == "," && displayedText.contains(",") == false) {
					resultLabel.text = displayedText + buttonTitle
				}
			}
			else {
				resultLabel.text = (buttonTitle == "," ? "0," : buttonTitle)
			}
			isTyping = true
		}
	}

	@objc private func clickOperatorButton(_ sender: UIButton) {
		if let buttonTitle = sender.titleLabel?.text, let displayedText = resultLabel.text {
			print("operator")
		}
	}
	@objc private func clickActionsButton(_ sender: UIButton) {
		if let buttonTitle = sender.titleLabel?.text {
			if buttonTitle == "AC" || buttonTitle == "C" {
				resultLabel.text = "0"
				isTyping = false
			}
			else if buttonTitle == "+/-" {
				if let value = displayValue {
					displayValue = (-1) * value
				}
			}
			else if buttonTitle == "%" {
				if let value = displayValue {
					displayValue = value / 100
					isTyping = false
				}
			}
		}
	}

// MARK: - Функции настройки кнопок
//Создаем цифровую кнопку
	private func createNumberButton(title: String) -> UIButton {
		let button = UIButton(frame: .zero)
		setButtonProperties(button: button,
							title: title,
							hexBackgroundColor: "#333333",
							hexTitleColor: "#FFFFFF",
							fontSize: 36)
		return button
	}
// Создаем символьную кнопку
	private func createSymbolButton(title: String) -> UIButton {
		let button = UIButton(frame: .zero)
		setButtonProperties(button: button,
							title: title,
							hexBackgroundColor: "#AFAFAF",
							hexTitleColor: "#000000",
							fontSize: 30)
		return button
	}
//Создаем кнопку с оператором
	private func createOperatorButton(title: String) -> UIButton {
		let button = UIButton(frame: .zero)
		setButtonProperties(button: button,
							title: title,
							hexBackgroundColor: "#FF9500",
							hexTitleColor: "#FFFFFF",
							fontSize: 36)
		return button
	}
//Установка свойств для кнопки
	private func setButtonProperties(button: UIButton,
									 title: String,
									 hexBackgroundColor backgroundColor: String,
									 hexTitleColor titleColor: String,
									 fontSize: CGFloat ) {
		button.setTitle(title, for: .normal)
		button.backgroundColor = UIColor(hex: backgroundColor)
		button.setTitleColor(UIColor(hex: titleColor), for: .normal)
		button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: fontSize)
		if "0123456789,".contains(title) {
			button.addTarget(self, action: #selector(clickNumberButton), for: .touchUpInside)
		}
		else if "+-=×÷".contains(title) {
			button.addTarget(self, action: #selector(clickOperatorButton), for: .touchUpInside)
		}
		else {
			button.addTarget(self, action: #selector(clickActionsButton), for: .touchUpInside)
		}
	}

//Устанавливаем констрейнты для размеров для кнопок
	private func setUpButtonAspectRatioConstraints(_ button: UIButton) {
		if let text = button.titleLabel?.text, text != "0" {
			NSLayoutConstraint.activate([
						button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1),
					])
		}
	}
//Делаем кнопку круглой
	private func makeButtonRound(button: UIButton) {
		button.layoutIfNeeded()
		button.layer.cornerRadius = button.bounds.height / 2
	}

// MARK: - Функции настройки стэка
//Устанавливаем свойства для UIStackView
	private func setUpHorizontalStackView(stackView: UIStackView) {
		stackView.axis = .horizontal
		stackView.distribution = .fillProportionally
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.translatesAutoresizingMaskIntoConstraints = false
	}
//Устанавливаем свойства для главного StackView
	private func setUpVerticalStackView(stackView: UIStackView) {
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.alignment = .fill
		stackView.spacing = 14
		stackView.translatesAutoresizingMaskIntoConstraints = false
	}
//Устанавливаем topAnchor и TrailingAnchor для стека по размеру родительского
	private func setHorizontalStackConstraints(stackView: UIStackView, parentStackView: UIStackView) {
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: parentStackView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: parentStackView.trailingAnchor),
		])
	}
//Устанавливаем констрейнты для вертикального стека
	private func setVerticalStackConstraints(stackView: UIStackView, parentView: UIView) {
		NSLayoutConstraint.activate([
			stackView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -16),
			stackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 16),
			stackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -17),
		])
	}
// MARK: - Функции настройки лейбла с результатом
	//Устанавливаем настройки для лейбла по-умолчанию
	private func setUpResultLabel(label: UILabel) {
		label.text = "0"
		label.font = UIFont(name: "FiraSans-Light", size: 94)
		label.textColor = UIColor(hex: "#FFFFFF")
		label.textAlignment = .right
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.2
	}
}
