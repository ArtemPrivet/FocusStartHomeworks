//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController
{
	// MARK: - Properties
	private let calculatorView = CalculatorView()
	private var calculator = Calculator()
	private var isUserInTheMiddleOfInput = false
	private var formatter = DisplayFormatter.shared.format

	private var displayValue: Double? {
		get {
			guard let displayText = calculatorView.displayLabel.text else { return nil }
			return formatter.number(from: displayText)?.doubleValue
		}
		set {
			if let value = newValue {
				formatter.numberStyle = DisplayFormatter.automaticNumberStyle(with: value)
				calculatorView.displayLabel.text = formatter.string(from: NSNumber(value: value))
			}
		}
	}

	var displayResult: (result: Double?, isWaiting: Bool) = (nil, false) {
		didSet {
			if let result = displayResult.result {
				displayValue = result
			}
		}
	}

	// MARK: - Super Class Properties
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	// MARK: - Vc Life Cycle Methods
	override func loadView() {
		view = calculatorView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		addTargetToButtons()
		addSwipeToLabel()
	}
}

// MARK: - PRIVATE METHODS
private extension CalculatorViewController
{
	// MARK: Buttons Handling
	private func addTargetToButtons() {
		for button in calculatorView.buttonsStack.cells {
			guard let title = button.currentTitle else { return }
			let isDigitOrSeparator = (Int(title) != nil) ||
				(button.currentTitle == formatter.decimalSeparator)
			if isDigitOrSeparator {
				// это число или сепаратор
				button.addTarget(self, action: #selector(digitTapped(_:)), for: .touchUpInside)
			}
			else {
				// это оператор
				button.addTarget(self, action: #selector(operatorTapped(_:)), for: .touchUpInside)
			}
		}
	}

	@objc private func digitTapped(_ sender: Button) {
		guard let digit = sender.currentTitle else { return }
		guard let currentTextInDisplay = calculatorView.displayLabel.text else { return }
		let digitsCount = currentTextInDisplay.filter { $0.isNumber }.count

		let isDigitNotSeparator = (digit != formatter.decimalSeparator)
		let isOnlyZeroOnDisplay = (currentTextInDisplay == Sign.zero)
		let displayHasNoSeparator = (currentTextInDisplay.contains(formatter.decimalSeparator) == false)
		let notAllowsDoubleSeparator = (isDigitNotSeparator || displayHasNoSeparator)

		if isUserInTheMiddleOfInput && isOnlyZeroOnDisplay == false {
			// юзер уже что то ввел ранее
			if notAllowsDoubleSeparator {
				if digitsCount < 9 {
					calculatorView.displayLabel.text = currentTextInDisplay + digit
				}
				if isDigitNotSeparator {
					updateDisplayLabel()
				}
			}
		}
		else {
			// начала ввода
			calculatorView.displayLabel.text = isDigitNotSeparator ? digit : Sign.zero + digit
			isUserInTheMiddleOfInput = true
		}
		switchClearButtonTitle()
		setSelectedButtonState(of: sender)
	}

	/// юзер нажал на один из операторов
	@objc private func operatorTapped(_ sender: Button) {
		guard userTappedClear(sender) == false else { return }

		if isUserInTheMiddleOfInput || calculatorView.displayLabel.text == Sign.zero {
			if let value = displayValue {
				calculator.setOperand(value)
			}

			isUserInTheMiddleOfInput = false
		}

		if let operationSign = sender.currentTitle {
			if calculator.hasLastResult {
				if let value = displayValue {
					calculator.setOperand(value)
				}
			}
			calculator.setOperation(operationSign)
		}

		setSelectedButtonState(of: sender)
		displayResult = calculator.evaluate()
	}

	/// чистит экран / модель
	private func userTappedClear(_ button: Button) -> Bool {
		if button.currentTitle == Sign.clear {
			calculatorView.displayLabel.text = Sign.zero
			switchClearButtonTitle()
			return true
		}
		if button.currentTitle == Sign.allClear {
			isUserInTheMiddleOfInput = false
			calculator.allClear()
			displayValue = 0
			displayResult = calculator.evaluate()
			return true
		}
		return false
	}

	/// переключает состояние кнопок
	private func setSelectedButtonState(of sender: Button) {
		switch sender.currentTitle {
		case Sign.divide, Sign.multiply, Sign.minus, Sign.plus:
			sender.isSelected = true
			calculatorView.buttonsStack.cells.forEach {  button in
				if sender != button {
					button.isSelected = false
				}
			}
		default:
			calculatorView.buttonsStack.cells.forEach { $0.isSelected = false }
		}
	}

	private func switchClearButtonTitle() {
		// AC <-> C
		calculatorView.buttonsStack.cells.first?.setTitle(
			isUserInTheMiddleOfInput && calculatorView.displayLabel.text != Sign.zero ? "C" : "AC",
			for: .normal
		)
	}
	// MARK: Label Handling
	private func updateDisplayLabel() {
		let filtered = calculatorView.displayLabel.text?
			.filter { $0.isNumber || $0.isMathSymbol || $0.isPunctuation }
			.replacingOccurrences(of: ",", with: ".")
		if let filter = filtered, let double = Double(filter) {
			formatter.numberStyle = DisplayFormatter.automaticNumberStyle(with: double)
			calculatorView.displayLabel.text = formatter.string(from: NSNumber(value: double))
		}
	}

	private func addSwipeToLabel() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnLabel))
		swipeRecognizer.direction = [.left, .right]
		calculatorView.displayLabel.isUserInteractionEnabled = true
		calculatorView.displayLabel.addGestureRecognizer(swipeRecognizer)
	}

	@objc private func swipeOnLabel() {
		guard calculator.hasLastResult == false else { return }
		if calculatorView.displayLabel.text?.isEmpty == false {
			if calculatorView.displayLabel.text != Sign.zero {
				calculatorView.displayLabel.text?.removeLast()
				updateDisplayLabel()
				if calculatorView.displayLabel.text?.first == nil {
					calculatorView.displayLabel.text = Sign.zero
				}
			}
			else {
				displayValue = 0
			}
		}
	}
}
