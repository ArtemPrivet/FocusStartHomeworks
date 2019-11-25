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
			return getDisplayValue()
		}
		set {
			setDisplayValue(newValue: newValue)
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
			.createStackFromButtons(buttons: [
				getButtonByTitle(title: "AC"),
				getButtonByTitle(title: "+/-"),
				getButtonByTitle(title: "%"),
				getButtonByTitle(title: "÷"),
			]))
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [
				getButtonByTitle(title: "7"),
				getButtonByTitle(title: "8"),
				getButtonByTitle(title: "9"),
				getButtonByTitle(title: "✕"),
			]))
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [
				getButtonByTitle(title: "4"),
				getButtonByTitle(title: "5"),
				getButtonByTitle(title: "6"),
				getButtonByTitle(title: "－"),
			]))
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [
				getButtonByTitle(title: "1"),
				getButtonByTitle(title: "2"),
				getButtonByTitle(title: "3"),
				getButtonByTitle(title: "＋"),
			]))
		horizontalStacks.append(stackCreator
			.createStackFromButtons(buttons: [
				getButtonByTitle(title: "0"),
				getButtonByTitle(title: ","),
				getButtonByTitle(title: "＝"),
			]))

		let verticalStack = stackCreator.createVerticalStack(from: horizontalStacks)

		self.view.addSubview(verticalStack)
		//Устанавливаем констрейнты для вертикального стэка
		stackCreator.setVerticalStackConstraints(stackView: verticalStack, safeAreaMargins: margins )
		//Настраиваем лейбл для вывода результата
		labelCreator.setUpLabelWithGestureRecognizer(label: resultLabel, recognizer: swipeGestureGecognizer)
		self.view.addSubview(resultLabel)
		//Настраиваем констрейнты для лейбла
		labelCreator.setUpLabelConstraints(label: resultLabel, bottomView: verticalStack, safeAreaMargins: margins)
	}
	//Закругление кнопок и настройка выравнивания 0 на кнопке
	private func finalCustomize() {
		//Закругляем все кнопки
		buttons.forEach{ buttonCreator.makeButtonRound(button: $0) }
		//Выравниваем текст на кнопке "0" по левому краю
		if let zeroButton = getButtonByTitle(title: "0") {
			buttonCreator.setUpTextAlignmentOnZeroButton(button: zeroButton)
		}
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
		buttonCreator.resetColorSettingsForOperationButton(buttons: buttons)
		buttonCreator.animateButtonTap(button: sender)
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
		buttonCreator.resetColorSettingsForOperationButton(buttons: buttons)
		buttonCreator.animateButtonTap(button: sender)
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
		guard let clearButton = getButtonByTitle(title: "AC", secondTitle: "C") else { return }
		if let text = resultLabel.text, text != "0" || isTyping {
			clearButton.setTitle("C", for: .normal)
		}
		else {
			clearButton.setTitle("AC", for: .normal)
		}
	}
	//Вернуть кнопку с заданным заголовком
	private func getButtonByTitle(title: String, secondTitle: String = "") -> UIButton? {
		let filteredArray = buttons.filter{ $0.titleLabel?.text == title || $0.titleLabel?.text == secondTitle }
		return filteredArray.count == 1 ? filteredArray[0] : nil
	}
	//Вернуть текущее значение с дисплея
	private func getDisplayValue() -> Double? {
		if let text = resultLabel.text {
			return Double(text.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: ""))
		}
		else {
			return 0
		}
	}
	//Установить значение на дисплее
	private func setDisplayValue(newValue: Double?) {
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
