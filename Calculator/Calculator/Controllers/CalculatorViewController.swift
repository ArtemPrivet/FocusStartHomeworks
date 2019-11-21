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
		toggleButtonState(of: sender)
	}

	@objc private func operatorTapped(_ sender: Button) {
		allClear(ifNeeded: sender.currentTitle)

		if isUserInTheMiddleOfInput || calculatorView.screenLabel.text == Sign.zero {
			if let value = displayValue {
				calculator.setOperand(value)
			}
			isUserInTheMiddleOfInput = false
		}

		if let operationSign = sender.currentTitle {
			calculator.performCalculation(operationSign)
		}

		displayValue = calculator.result
		toggleButtonState(of: sender)
		if let description = calculator.description {
			let output = description + (calculator.resultIsWaiting ? "..." : "=")
			print(output)
		}
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
		case Sign.percent, Sign.clear, Sign.changeSign: return
		default:
			calculatorView.buttonsStack.cells.forEach { $0.isSelected = false }
		}
		toggleClearButtonTitle()
	}

	private func allClear(ifNeeded sign: String?) {
		if sign == "C" {
			displayValue = 0
			toggleClearButtonTitle()
			return
		}
		if sign == "AC" {
			calculator.allClear()
			displayValue = 0
		}
		toggleClearButtonTitle()
	}
	private func toggleClearButtonTitle() {
		// AC <-> C
		if isUserInTheMiddleOfInput {
			calculatorView.buttonsStack.cells.first?.setTitle(
				isUserInTheMiddleOfInput && calculatorView.screenLabel.text != Sign.zero ? "C" : "AC",
				for: .normal
			)
		}
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
