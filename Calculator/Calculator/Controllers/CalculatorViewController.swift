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
	private let zero = "0"
	private var isUserInTheMiddleOfInput = false

	private var displayValue: Double? {
		get {
			guard let displayText = calculatorView.screenLabel.text else { return nil }
			return formatter.number(from: displayText)?.doubleValue
		}
		set {
			if let value = newValue {
				let maxNumber = 999_999_999.9
				formatter.numberStyle = (value > maxNumber || value < -maxNumber) ? .scientific : .decimal
				formatter.maximumFractionDigits = defineFormatterDigits(value: value)
					calculatorView.screenLabel.text = formatter.string(from: NSNumber(value: value))
			}
		}
	}

	private func updateDisplay() {
		let filtered = calculatorView.screenLabel.text?
			.filter { $0.isNumber || $0.isMathSymbol || $0.isPunctuation }
			.replacingOccurrences(of: ",", with: ".")
		if let filter = filtered {
			if let double = Double(filter) {
				let maxNumber = 999_999_999.0
				formatter.numberStyle = (double > maxNumber || double < -maxNumber) ? .scientific : .decimal
				calculatorView.screenLabel.text = formatter.string(from: NSNumber(value: double))
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
		sender.blink()

		guard let digit = sender.currentTitle else { return }
		guard let currentTextInDisplay = calculatorView.screenLabel.text else { return }
		let digitsCount = currentTextInDisplay.filter { $0.isNumber }.count

		let isDigitNotSeparator = (digit != formatter.decimalSeparator)
		let isOnlyZeroOnDisplay = (currentTextInDisplay == zero)
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
			// new input
			calculatorView.screenLabel.text = isDigitNotSeparator ?  digit : zero + digit
			isUserInTheMiddleOfInput = true
		}

		toggleClearButtonTitle()
	}

	@objc private func operatorTapped(_ sender: Button) {
		//sender.reverseColors()
		sender.blink()
		if isUserInTheMiddleOfInput || calculatorView.screenLabel.text == zero {
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

		private func toggleClearButtonTitle() {
			// AC <-> C
			calculatorView.buttonsStack.cells.first?.setTitle(
				calculatorView.screenLabel.text != zero ? "C" : "AC",
				for: .normal
			)
		}

	// MARK: - LABEL HANDLING
	private func addSwipeToLabel() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnLabel))
		swipeRecognizer.direction = [.left, .right]
		calculatorView.screenLabel.isUserInteractionEnabled = true
		calculatorView.screenLabel.addGestureRecognizer(swipeRecognizer)
	}

	@objc private func swipeOnLabel() {
		if calculatorView.screenLabel.text?.isEmpty == false {
			if calculatorView.screenLabel.text != zero {
				calculatorView.screenLabel.text?.removeLast()
				updateDisplay()
				if calculatorView.screenLabel.text?.first == nil {
					calculatorView.screenLabel.text = zero
				}
			}
			else {
				displayValue = 0
			}
		}
	}
}
// MARK: DEFINE MAX FRACTION DIGITS
extension CalculatorViewController
{
	 func defineFormatterDigits(value: Double) -> Int {
		switch value {
		case 0...10: return 8
		case 10...100: return 7
		case 100...1000: return 6
		case 1000...10_000: return 5
		case 10_000...100_000: return 4
		case 100_000...1_000_000: return 3
		case 10_000_000...100_000_000: return 2
		default : return 1
		}
	}
}
