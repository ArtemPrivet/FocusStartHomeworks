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
	private lazy var formatter = calculatorView.buttonsStack.formatter

	private var calculator = Calculator()
	private var isUserInTheMiddleOfInput = false

	private var displayValue: Double? {
		get {
			let displayText = calculatorView.screenLabel.text?
				.filter { $0.isNumber || $0.isMathSymbol || $0.isPunctuation }
				.replacingOccurrences(of: ",", with: ".")
			guard let filteredText = displayText else { return nil }
			return formatter.number(from: filteredText)?.doubleValue
		}
		set {
			updateDisplay(with: newValue)
		}
	}

	private func updateDisplay(with value: Double?) {
		if let value = value {
		let maxNumber = 999_999_999.0
		formatter.numberStyle = (value > maxNumber || value < -maxNumber) ? .scientific : .decimal
		calculatorView.screenLabel.text = formatter.string(from: NSNumber(value: value))
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
		sender.blink()

		guard let digit = sender.currentTitle else { return }
		guard let currentTextInDisplay = calculatorView.screenLabel.text else { return }
		let zero = "0"
		let isDigitNotSeparator = (digit != formatter.decimalSeparator)
		let isOnlyZeroOnDisplay = (currentTextInDisplay == zero)
		let displayHasNoSeparator = (currentTextInDisplay.contains(formatter.decimalSeparator) == false)
		let notAllowsDoubleSeparator = (isDigitNotSeparator || displayHasNoSeparator)
		let digitsCount = currentTextInDisplay.filter { $0.isNumber }.count

		if isUserInTheMiddleOfInput && isOnlyZeroOnDisplay == false  {
			// user already typing something
			guard digitsCount < 9 else { return }
			if notAllowsDoubleSeparator {
				calculatorView.screenLabel.text = currentTextInDisplay + digit
			}
		}
		else {
			// new input
			calculatorView.screenLabel.text = isDigitNotSeparator ?  digit : zero + digit
			isUserInTheMiddleOfInput = true
		}
		updateDisplay(with: displayValue)
	}

	@objc private func operatorTapped(_ sender: Button) {
		//sender.reverseColors()
		sender.blink()

		if isUserInTheMiddleOfInput {
			if let value = displayValue {
			calculator.setOperand(value)
			}
			isUserInTheMiddleOfInput = false
		}

		if let operationSign = sender.currentTitle {
			calculator.performCalculation(operationSign)
		}

		displayValue = calculator.result
	}

	//	private func toggleClearButtonTitle() {
	//		// AC <-> C
	//		calculatorView.buttonsStack.cells.first?.setTitle(
	//			calculatorView.screenLabel.text != zero ? Sign.clear.rawValue : Sign.allClear.rawValue,
	//			for: .normal
	//		)
	//	}

	// MARK: - LABEL HANDLING

	private func addSwipeToLabel() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnLabel))
		swipeRecognizer.direction = [.left, .right]
		calculatorView.screenLabel.isUserInteractionEnabled = true
		calculatorView.screenLabel.addGestureRecognizer(swipeRecognizer)
	}

	@objc private func swipeOnLabel() {
//		if calculatorView.screenLabel.text?.isEmpty == false {
//			if calculatorView.screenLabel.text != zero {
//				calculatorView.screenLabel.text?.removeLast()
//				if calculatorView.screenLabel.text?.first == nil {
//					calculatorView.screenLabel.text = zero
//				}
//			}
//			else {
//				displayValue = 0
//			}
//		}
	}
}
