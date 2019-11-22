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
	// MARK: - PROPERTIES
	private let calculatorView = CalculatorView()
	private var calculator = Calculator()
	private var isUserInTheMiddleOfInput = false
	private var formatter = MyFormatter.shared.format
	private var variableValues = [String: Double]()

	private var displayValue: Double? {
		get {
			guard let displayText = calculatorView.screenLabel.text else { return nil }
			return formatter.number(from: displayText)?.doubleValue
		}
		set {
			if let value = newValue {
				MyFormatter.shared.switchFormatterNumberStyle(with: value)
				calculatorView.screenLabel.text = formatter.string(from: NSNumber(value: value))
			}
		}
	}

	var displayResult: (result: Double?, isWaiting: Bool) = (nil, false) {
		didSet {
			switch displayResult {
//			case (nil, _) : displayValue = 0
			case (let result, _): displayValue = result
			}
		}
	}

	// MARK: - SUPER CLASS PROPERTIES
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	// MARK: - VC LIFE CYCLE METHODS
	override func loadView() {
		view = calculatorView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		addTargetToButtons()
		addSwipeToLabel()
	}

	// MARK: - BUTTONS HANDLING
	private func addTargetToButtons() {
		for button in calculatorView.buttonsStack.cells {
			guard let title = button.currentTitle else { return }
			let isDigitOrSeparator = (Int(title) != nil) ||
				(button.currentTitle == formatter.decimalSeparator)
			if isDigitOrSeparator {
				// it's a some number
				button.addTarget(self, action: #selector(digitTapped(_:)), for: .touchUpInside)
			}
			else {
				// it's an operator
				button.addTarget(self, action: #selector(operatorTapped(_:)), for: .touchUpInside)
			}
		}
	}

	@objc private func digitTapped(_ sender: Button) {
		guard let digit = sender.currentTitle else { return }
		guard let currentTextInDisplay = calculatorView.screenLabel.text else { return }
		let digitsCount = currentTextInDisplay.filter { $0.isNumber }.count

		let isDigitNotSeparator = (digit != formatter.decimalSeparator)
		let isOnlyZeroOnDisplay = (currentTextInDisplay == Sign.zero)
		let displayHasNoSeparator = (currentTextInDisplay.contains(formatter.decimalSeparator) == false)
		let notAllowsDoubleSeparator = (isDigitNotSeparator || displayHasNoSeparator)

		if isUserInTheMiddleOfInput && isOnlyZeroOnDisplay == false {
			// user already typing something
			if notAllowsDoubleSeparator {
				if digitsCount < 9 {
					calculatorView.screenLabel.text = currentTextInDisplay + digit
				}
				if isDigitNotSeparator {
					updateDisplay()
				}
			}
		}
		else {
			// begin of user input
			calculatorView.screenLabel.text = isDigitNotSeparator ?  digit : Sign.zero + digit
			isUserInTheMiddleOfInput = true
		}
		toggleClearButtonTitle()
		toggleButtonState(of: sender)
	}

	@objc private func operatorTapped(_ sender: Button) {
		clear(ifNeeded: sender.currentTitle)
		if isUserInTheMiddleOfInput || calculatorView.screenLabel.text == Sign.zero {
			if let value = displayValue {
				calculator.setOperand(value)
			}
			isUserInTheMiddleOfInput = false
		}

		if let operationSign = sender.currentTitle {
			calculator.setOperation(operationSign)
		}

		toggleButtonState(of: sender)
		displayResult = calculator.evaluate(using: variableValues)
	}

	private func toggleButtonState(of sender: Button) {
		switch sender.currentTitle {
		case Sign.divide, Sign.multiply, Sign.minus, Sign.plus:
			sender.isSelected = true
			calculatorView.buttonsStack.cells.forEach {  button in
				if sender != button {
					button.isSelected = false
				}
			}
		case Sign.percent, Sign.clear, Sign.changeSign:
			 setVariable(of: sender)
		default:
			calculatorView.buttonsStack.cells.forEach { $0.isSelected = false }
		}
	}

	private func clear(ifNeeded sign: String?) {
		if sign == "C" {
			toggleClearButtonTitle()
			displayResult = calculator.evaluate(using: variableValues)
			displayValue = 0
			toggleClearButtonTitle()
			return
		}
		if sign == "AC" {
			isUserInTheMiddleOfInput = false
			calculator.clear()
			variableValues = [:]
			displayResult = calculator.evaluate(using: variableValues)
		}
	}
	private func toggleClearButtonTitle() {
		// AC <-> C
		calculatorView.buttonsStack.cells.first?.setTitle(
				isUserInTheMiddleOfInput && calculatorView.screenLabel.text != Sign.zero ? "C" : "AC",
				for: .normal
			)
	}

	// MARK: - LABEL HANDLING
	private func updateDisplay() {
		let filtered = calculatorView.screenLabel.text?
			.filter { $0.isNumber || $0.isMathSymbol || $0.isPunctuation }
			.replacingOccurrences(of: ",", with: ".")
		if let filter = filtered {
			if let double = Double(filter) {
				MyFormatter.shared.switchFormatterNumberStyle(with: double)
				calculatorView.screenLabel.text = formatter.string(from: NSNumber(value: double))
			}
		}
	}

	private func addSwipeToLabel() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnLabel))
		swipeRecognizer.direction = [.left, .right]
		calculatorView.screenLabel.isUserInteractionEnabled = true
		calculatorView.screenLabel.addGestureRecognizer(swipeRecognizer)
	}

	@objc private func swipeOnLabel() {
		if calculatorView.screenLabel.text?.isEmpty == false {
			if calculatorView.screenLabel.text != Sign.zero {
				calculatorView.screenLabel.text?.removeLast()
				updateDisplay()
				if calculatorView.screenLabel.text?.first == nil {
					calculatorView.screenLabel.text = Sign.zero
				}
			}
			else {
				displayValue = 0
			}
		}
	}
}

//variables
extension CalculatorViewController
{
	func setVariable(of button: Button) {
		isUserInTheMiddleOfInput = false
		guard let symbol = button.currentTitle else { return }
		variableValues[symbol] = displayValue
		displayResult = calculator.evaluate(using: variableValues)
	}

	func pushVariable(of button: Button) {
		guard let symbol = button.currentTitle else { return }
		calculator.setOperand(variable: symbol)
		displayResult = calculator.evaluate(using: variableValues)
	}
}
