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
	private let buttonCreator = ButtonCreator()
	private let stackCreator = StackCreator()
	private let labelCreator = LabelCreator()
	private let calculations = Calculations()
	private let resultLabel = UILabel()
	private let enteredNumbersLimit = 9

	private var buttons: [UIButton] = []
	private var horizontalStacks: [UIStackView] = []
	private var swipeGestureGecognizer = UISwipeGestureRecognizer()
	private var margins = UILayoutGuide()
	private var isTyping = false

	private var displayValue: Double? {
		get {
			if let text = resultLabel.text {
				return Double(text.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: ""))
			}
			else {
				return 0
			}
		}
		set {
			if let value: Double = newValue {
				if value.isInfinite {
					resultLabel.text = "Ошибка"
				}
				else {
					let formatter = NumberFormatter()
					formatter.minimumFractionDigits = 0
					formatter.maximumFractionDigits = 8
					let stringValue = formatter.string(from: NSNumber(value: value)) ?? "0"
					resultLabel.text = stringValue.replacingOccurrences(of: ".", with: ",")
				}
			}
			else {
				resultLabel.text = "0"
			}
			refreshACButtonTitle()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		margins = self.view.layoutMarginsGuide

		self.view.backgroundColor = UIColor(hex: "#000000")
		swipeGestureGecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftOnLabel))
		swipeGestureGecognizer.direction = .left

		createControls()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		finalCustomize()
	}
	// MARK: - Создание контролов
	private func createControls() {
		//Создаем массив кнопок
		buttons = buttonCreator.createCalculatorButtons()

		guard buttons.count == 19 else { fatalError("Wrong number of buttons") }
		buttons.forEach{ setUpButtonActions($0) }
		//Складываем кнопки в стэк
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [buttons[16], buttons[17], buttons[18], buttons[15]]))
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [buttons[7], buttons[8], buttons[9], buttons[14]]))
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [buttons[4], buttons[5], buttons[6], buttons[13]]))
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [buttons[1], buttons[2], buttons[3], buttons[12]]))
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [buttons[0], buttons[10], buttons[11]]))

		let verticalStack = stackCreator.createVerticalStack(from: horizontalStacks)

		self.view.addSubview(verticalStack)
		//Устанавливаем констрейнты для вертикального стэка
		stackCreator.setVerticalStackConstraints(stackView: verticalStack, safeAreaMargins: margins )
		//Настраиваем лейбл для вывода результата
		labelCreator.setUpLabelWithGestureRecognizer(label: resultLabel, recognizer: swipeGestureGecognizer)
		self.view.addSubview(resultLabel)
		//Настраиваем констрейнты для лейбла
		labelCreator.setUpLabelConstraints(label: resultLabel, bottomView: verticalStack, safeAreaMargins: margins)
		//Настраиваем констрейнты для кнопки 0
		buttons[0].widthAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 0.5, constant: -7).isActive = true
	}
	//Закругление кнопок и настройка выравнивания 0 на кнопке
	private func finalCustomize() {
		//Закругляем все кнопки
		buttons.forEach{ buttonCreator.makeButtonRound(button: $0) }
		//Выравниваем текст на кнопке "0" по левому краю
		buttons[0].contentHorizontalAlignment = .center
		buttons[0].titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: buttons[10].bounds.width + 14)
	}

	// MARK: - Настройка взаимодействия
	//Настройка нажатия кнопок
	private func setUpButtonActions(_ button: UIButton) {
		guard let title = button.titleLabel?.text else { return }
		if "0123456789,".contains(title) {
			button.addTarget(self, action: #selector(clickNumberButton), for: .touchUpInside)
		}
		else {
			button.addTarget(self, action: #selector(clickOperatorButton), for: .touchUpInside)
		}
	}

	//Обработка нажатий по цифрам и запятой
	@objc private func clickNumberButton(_ sender: UIButton) {
		guard let buttonTitle = sender.titleLabel?.text, let displayedText = resultLabel.text else { return }
		guard displayedText.count + 1 <= enteredNumbersLimit || isTyping == false else { return }
		if isTyping {
			if buttonTitle != "," || (buttonTitle == "," && displayedText.contains(",") == false) {
				if displayedText != "0" {
					resultLabel.text = displayedText + buttonTitle
				}
				else {
					resultLabel.text = (buttonTitle == "," ? "0," : buttonTitle)
				}
			}
		}
		else {
			resultLabel.text = (buttonTitle == "," ? "0," : buttonTitle)
		}
		isTyping = true

		refreshACButtonTitle()
	}
	//Обработка действий кнопок операторов
	@objc private func clickOperatorButton(_ sender: UIButton) {
		guard let buttonTitle = sender.titleLabel?.text else { return }
		if isTyping, let value = displayValue {
			calculations.setOperand(operand: value)
			isTyping = false
		}
		calculations.makeOperation(symbol: buttonTitle)
		displayValue = calculations.result
	}
	//Обработка свайпа
	@objc private func swipeLeftOnLabel(_ sender: UISwipeGestureRecognizer) {
		guard isTyping, let text = resultLabel.text else { return }
		let newText = String(text.dropLast())
		if newText.count > 0 {
			resultLabel.text = newText
		}
		else {
			resultLabel.text = "0"
			isTyping = false
		}
	}
	//Настраиваем заголовок для кнопки AC
	private func refreshACButtonTitle() {
		if let text = resultLabel.text, text != "0" || isTyping {
			buttons[16].setTitle("C", for: .normal)
		}
		else {
			buttons[16].setTitle("AC", for: .normal)
		}
	}
}
