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

	private var buttons: [[ButtonView?]] {
		// swiftlint:disable multiline_literal_brackets
		// swiftlint:disable trailing_comma
		[
			[ButtonView(type: .operator("AC"),
						backgroundColor: AppSetting.Color.otherOperator,
						textColor: AppSetting.Color.darkText,
						tapHandler: actionClear),
			 // \u{207A}\u{2215}\u{208B}
			 ButtonView(type: .operator("⁺∕₋"),
						backgroundColor: AppSetting.Color.otherOperator,
						textColor: AppSetting.Color.darkText,
						tapHandler: actionPerformOperation),
			 ButtonView(type: .operator("%"),
						backgroundColor: AppSetting.Color.otherOperator,
						textColor: AppSetting.Color.darkText,
						tapHandler: actionPerformOperation),
			 // \u{00F7}
			 ButtonView(type: .operator("÷"),
						backgroundColor: AppSetting.Color.mainOperator,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionPerformOperation)],
			[ButtonView(type: .digit(7),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .digit(8),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .digit(9),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 // \u{00D7}
			 ButtonView(type: .operator("×"),
						backgroundColor: AppSetting.Color.mainOperator,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionPerformOperation)],
			[ButtonView(type: .digit(4),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .digit(5),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .digit(6),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .operator("−"),
						backgroundColor: AppSetting.Color.mainOperator,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionPerformOperation)],
			[ButtonView(type: .digit(1),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .digit(2),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .digit(3),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .operator("+"),
						backgroundColor: AppSetting.Color.mainOperator,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionPerformOperation)],
			[ButtonView(type: .digit(0),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 nil,
			 ButtonView(type: .other(","),
						backgroundColor: AppSetting.Color.digit,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionTouchDigit),
			 ButtonView(type: .other("="),
						backgroundColor: AppSetting.Color.mainOperator,
						textColor: AppSetting.Color.lightText,
						tapHandler: actionPerformOperation)]
		]
		// swiftlint:enable multiline_literal_brackets
		// swiftlint:enable trailing_comma
	}

	private let countOfRows = 5
	private let countOfColumns = 4

	private var resultView = ResultView(backgroundColor: AppSetting.Color.background,
										textColor: AppSetting.Color.lightText)
	private lazy var buttonsAreaView: ButtonsAreaView = {
		let buttonsArea = ButtonsAreaView(buttons: buttons,
										  rows: countOfRows,
										  columns: countOfColumns,
										  backgroundColor: AppSetting.Color.background)
		return buttonsArea
	}()

	private var userInTheMiddleOfTyping = false

	private var calculator = Calculator()

	let decimalSeparator = AppSetting.formatter.decimalSeparator ?? ","

	var displayValue: Double? {
		get {
			guard let text = resultView.text else { return nil }
			return Double(text)
		}
		set {
			guard let value = newValue else { return }
			resultView.text = AppSetting.formatter.string(from: NSNumber(value: value))
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = AppSetting.Color.background
		self.view.addSubview(resultView)
		self.view.addSubview(buttonsAreaView)
		setConstraints()
	}

	private func setConstraints() {
		var selfView: UILayoutGuide
		if #available(iOS 11.0, *) {
			selfView = self.view.safeAreaLayoutGuide
		}
		else {
			selfView = self.view.layoutMarginsGuide
		}
		resultView.snp.makeConstraints { maker in
			maker.leading.equalTo(selfView).offset(15)
			maker.trailing.equalTo(selfView).offset(-17)
			maker.height.equalTo(113)
		}
		buttonsAreaView.snp.makeConstraints { maker in
			maker.leading.trailing.equalToSuperview()
			maker.bottom.equalTo(selfView)
			maker.top.equalTo(resultView.snp.bottom).offset(8)
			maker.height.equalTo(buttonsAreaView.snp.width).multipliedBy(CGFloat(countOfRows) / CGFloat(countOfColumns))
		}
	}

	private var currentOperateSymbol: String?
}

// MARK: - Actions
@objc extension CalculatorViewController
{

	private func actionTouchDigit(_ digit: String) {
		print(digit)
		guard userInTheMiddleOfTyping else {
			resultView.text = digit
			userInTheMiddleOfTyping = true
			return
		}
		let currentText = resultView.text ?? ""
		guard digit != decimalSeparator || currentText.contains(decimalSeparator) == false else { return }
		resultView.text = currentText + digit
	}

	private func actionPerformOperation(_ symbol: String) {
		print(symbol)
		if userInTheMiddleOfTyping {
			if let value = displayValue {
				calculator.pushOperand(value)
			}
			userInTheMiddleOfTyping = false
		}
		calculator.performOperation(symbol)
		displayValue = calculator.result
	}

	private func actionClear(_ title: String) {
		calculator.clear()
		displayValue = 0
		userInTheMiddleOfTyping = false
		print("Calculator has been reset")
	}

	private func backspace() {
		guard userInTheMiddleOfTyping, let text = resultView.text, text.isEmpty == false else { return }
		resultView.text = String(resultView.text?.dropLast() ?? "")
		if let text = resultView.text, text.isEmpty {
			displayValue = 0
		}
	}
}
