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

	var buttons = [ButtonView]()
	var resultLabel = UILabel()

	var resultNumber = 0
	var firstOperand = 0.0
	var secondOperand = 0.0
	var operatorSign = ""
	var isPressedAcButton = false
	var stillTyping = false
	var isFloatNumber = false

	var currentInput: Double {
		get {
			return Double(resultLabel.text ?? "") ?? 0
		}
		set {
			if String(newValue).hasSuffix(".0") {
				resultLabel.text = String(Int(newValue))
			}
			else {
				resultLabel.text = String(newValue)
			}
			stillTyping = false
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .black
		addButtonActions()
	}

	override func loadView() {
		let calcView = CalcalatorView()
		self.view = calcView
		resultLabel = calcView.resultLabel
		buttons = calcView.buttons.sorted(by: { button1, button2 -> Bool in
			button1.tag < button2.tag
		})
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupSubViews()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	func setupSubViews() {
		buttons.forEach { button in
			if button.tag == 0 {
				button.contentHorizontalAlignment = .left
				button.contentEdgeInsets = UIEdgeInsets(top: 0, left: button.frame.height / 2 - 7, bottom: 0, right: 0)
			}
			button.layer.cornerRadius = button.bounds.height / 2
		}
	}

	func addButtonActions() {
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

	// MARK: - Button functions
	@objc func floatButtonPressed(_ sender: ButtonView) {
		if stillTyping && isFloatNumber == false {
			resultLabel.text = (resultLabel.text ?? "") + ","
			isFloatNumber = true
		}
		else if stillTyping && isFloatNumber == false {
			resultLabel.text = "0,"
		}
	}

	@objc func percentButtonPressed(_ sender: ButtonView) {
		if firstOperand == 0 {
			currentInput /= 100
		}
		else {
			secondOperand = firstOperand * currentInput / 100
		}
	}

	@objc func negativeSwitchButtonPressed(_ sender: ButtonView) {
		currentInput *= -1
	}

	@objc func clearButtonPressed(_ sender: ButtonView) {
		firstOperand = 0
		secondOperand = 0
		currentInput = 0
		resultLabel.text = "0"
		stillTyping = false
		operatorSign = ""
		isFloatNumber = false
	}

	@objc func numberButtonPressed(_ sender: ButtonView) {
		if stillTyping {
			resultLabel.text = (resultLabel.text ?? "") + String(sender.tag)
		}
		else {
			resultLabel.text = String(sender.tag)
			stillTyping = true
		}
	}

	@objc func equalButtonPressed(_ sender: ButtonView) {
		if stillTyping {
			secondOperand = currentInput
		}

		switch operatorSign {
		case "+": makeOperation { $0 + $1 }
		case "-": makeOperation { $0 - $1 }
		case "*": makeOperation { $0 * $1 }
		case "/": makeOperation { $0 / $1 }
		default: break
		}
		isFloatNumber = false
	}
	@objc func operatorButtonPressed(_ sender: ButtonView) {
		equalButtonPressed(sender) //check for bug
		switch sender.tag {
		case OperationButtons.plus: operatorSign = "+"
		case OperationButtons.minus: operatorSign = "-"
		case OperationButtons.multiply: operatorSign = "*"
		case OperationButtons.divide: operatorSign = "/"
		default: break
		}
		firstOperand = currentInput
		stillTyping = false
		isFloatNumber = false
	}

	func makeOperation(_ operation: (Double, Double) -> Double) {
		currentInput = operation(firstOperand, secondOperand)
		stillTyping = false
	}
}
