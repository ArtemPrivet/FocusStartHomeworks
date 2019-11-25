//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController
{

	private var buttons = [CalculatorButton]()
	private var displayLabel = UILabel()

	private var resultNumber = 0
	private var firstOperand = 0.0
	private var secondOperand = 0.0
	private var operatorSign = ""
	private var isPressedAcButton = false
	private var isTyping = false
	private var isFloatNumber = false
	private var rpnExpression = [String]()
	private var converterRpn = ConverterRPN()

	var currentInput: Double {
		get {
			guard let text = displayLabel.text else { return 0 }
			return Double(text) ?? 0
		}
		set {
			let newValue = Double(round(100_000_000 * newValue) / 100_000_000)
			guard newValue.isInfinite == false else {
				displayLabel.text = "Error"
				return
			}
			if String(newValue).hasSuffix(".0") {
				displayLabel.text = String(String(newValue).dropLast(2)).replacedDot()
			}
			else {
				displayLabel.text = String(newValue).replacedDot()
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .black
		addButtonActions()
		addSwipeGestureToDispayLabel()
	}

	override func loadView() {
		let calculatorView = CalcalatorView()
		self.view = calculatorView
		displayLabel = calculatorView.displayLabel
		buttons = calculatorView.buttons.sorted(by: { $0.tag < $1.tag })
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	private func getPriority(str: String) -> Int {
		switch str {
		case "+", "-": return 1
		case "*", "/": return 2
		default: return 1
		}
	}

	private func addSwipeGestureToDispayLabel() {
		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(deleteSymbolFromLabel))
		swipeGestureRecognizer.direction = [.left, .right]
		displayLabel.addGestureRecognizer(swipeGestureRecognizer)
		displayLabel.isUserInteractionEnabled = true
	}

	@objc func deleteSymbolFromLabel() {
		guard isTyping, let labelText = displayLabel.text else { return }
		let newText = String(labelText.dropLast())
		if newText.count > 0 {
			displayLabel.text = newText
		}
		else {
			displayLabel.text = "0"
			isTyping = false
		}
	}

	private func addButtonActions() {
		buttons.forEach { button in
			switch button.tag {
			case 0...9:
				button.addTarget(self, action: #selector(numberButtonPressed), for: .touchUpInside)
			case 10:
				button.addTarget(self, action: #selector(floatButtonPressed), for: .touchUpInside)
			case 11:
				button.addTarget(self, action: #selector(equalButtonPressed), for: .touchUpInside)
			case 12...15:
				button.addTarget(self, action: #selector(operatorButtonPressed), for: .touchUpInside)
			case 16:
				button.addTarget(self, action: #selector(percentButtonPressed), for: .touchUpInside)
			case 17:
				button.addTarget(self, action: #selector(negativeSwitchButtonPressed), for: .touchUpInside)
			case 18:
				button.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
			default: break
			}
		}
	}

	@objc private func floatButtonPressed(_ sender: CalculatorButton) {
		if isTyping && isFloatNumber == false {
			displayLabel.text = (displayLabel.text ?? "") + "."
			isFloatNumber = true
		}
		else if isTyping == false && isFloatNumber == false {
			currentInput = Double(displayLabel.text ?? "") ?? 0.0
			displayLabel.text = "0."
			isFloatNumber = true
			isTyping = true
		}
	}

	@objc private func percentButtonPressed(_ sender: CalculatorButton) {
		if firstOperand == 0 {
			currentInput /= 100
		}
		else {
			currentInput = firstOperand * currentInput / 100
			secondOperand = currentInput
		}
	}

	@objc private func negativeSwitchButtonPressed(_ sender: CalculatorButton) {
		currentInput *= -1
	}

	@objc private func clearButtonPressed(_ sender: CalculatorButton) {
		buttons[OperationButtons.acAndC].setTitle("AC", for: .normal)
		rpnExpression.removeAll()
		firstOperand = 0
		secondOperand = 0
		currentInput = 0
		displayLabel.text = "0"
		isTyping = false
		operatorSign = ""
		isFloatNumber = false
	}

	@objc private func numberButtonPressed(_ sender: CalculatorButton) {
		buttons[OperationButtons.acAndC].setTitle("C", for: .normal)
		guard var displayText = displayLabel.text else { return }
		if isTyping {
			if displayText.count < 9 {
				if displayText.hasPrefix("0") && displayText.hasPrefix("0.") == false {
					displayText = String(displayText.dropFirst())
				}
				displayLabel.text = displayText + String(sender.tag)
			}
		}
		else {
			displayLabel.text = String(sender.tag)
			isTyping = true
		}
	}

	@objc private func operatorButtonPressed(_ sender: CalculatorButton) {
		if isTyping {
			rpnExpression.append(String(currentInput))
		}
		if isTyping && rpnExpression.count > 2 {
			if getPriority(str: rpnExpression[rpnExpression.count - 2]) >= getPriority(str: operatorSign) {
				currentInput = converterRpn.evaluateRpn(elements: rpnExpression)
			}
		}
		switch sender.tag {
		case OperationButtons.plus: operatorSign = "+"
		case OperationButtons.minus: operatorSign = "-"
		case OperationButtons.multiply: operatorSign = "*"
		case OperationButtons.divide: operatorSign = "/"
		default: break
		}
		if isTyping {
			rpnExpression.append(String(operatorSign))
		}
		firstOperand = currentInput
		isTyping = false
		isFloatNumber = false
	}

	@objc private func equalButtonPressed(_ sender: CalculatorButton) {
		if isTyping {
			rpnExpression.append(String(currentInput))
			secondOperand = currentInput
		}
		switch operatorSign {
		case "+": makeOperation { $0 + $1 }
		case "-": makeOperation { $0 - $1 }
		case "*": makeOperation { $0 * $1 }
		case "/": makeOperation { $0 / $1 }
		default: break
		}
		rpnExpression.removeAll()
		firstOperand = currentInput
		isTyping = true
		isFloatNumber = false
	}

	private func makeOperation(_ operation: (Double, Double) -> Double) {
		if isTyping && rpnExpression.count > 2 {
			if getPriority(str: rpnExpression[rpnExpression.count - 2]) >= getPriority(str: operatorSign) {
				currentInput = converterRpn.evaluateRpn(elements: rpnExpression)
			}
			else {
				currentInput = operation(firstOperand, secondOperand)
			}
		}
		isTyping = false
	}
}
