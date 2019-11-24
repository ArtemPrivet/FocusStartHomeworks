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

	// MARK: Private properties
	private var types: [[ButtonView.`Type`?]] {
		[
			[
				.other("AC"),
				.other(CalculatorEngine.Operator.magnitude.rawValue, AppSetting.SymbolIcon.magnitude),
				.other(CalculatorEngine.Operator.percent.rawValue),
				.mainOperator(CalculatorEngine.Operator.divide.rawValue, AppSetting.SymbolIcon.divide),
			],
			[
				.number(7),
				.number(8),
				.number(9),
				.mainOperator(CalculatorEngine.Operator.multiple.rawValue),
			],
			[
				.number(4),
				.number(5),
				.number(6),
				.mainOperator(CalculatorEngine.Operator.minus.rawValue),
			],
			[
				.number(1),
				.number(2),
				.number(3),
				.mainOperator(CalculatorEngine.Operator.plus.rawValue),
			],
			[
				.number(0),
				nil,
				.decimal(self.decimalSeparator),
				.mainOperator(CalculatorEngine.Operator.equals.rawValue),
			],
		]
	}

	private lazy var buttons: [[ButtonView?]] = {
		self.types.reduce(into: [[ButtonView?]]()) { matrixResult, rowOfType in
			let rowResult = rowOfType.reduce(into: [ButtonView?]()) { result, type in
				if case .other(let symbol, _) = type, symbol == "AC" {
					result.append(clearButtonView)
					return
				}
				guard let type = type else {
					result.append(nil)
					return
				}
				var tapHandler: ButtonView.Action
				switch type {
				case .number, .decimal: tapHandler = actionTouchDigit
				case .mainOperator, .other: tapHandler = actionPerformOperation
				}
				result.append(ButtonViewCreator.createButton(type: type, tapHandler: tapHandler))
			}
			matrixResult.append(rowResult)
		}
	}()

	private var countOfRows: Int { buttons.count }
	private var countOfColumns: Int { buttons[0].count }

	private var resultView = ResultView(backgroundColor: AppSetting.Color.background,
										textColor: AppSetting.Color.lightText)

	private lazy var buttonsAreaView =
		ButtonsAreaView(buttons: buttons,
						grid: (countOfRows, countOfColumns),
						offset: 14,
						backgroundColor: AppSetting.Color.background)

	private lazy var clearButtonView =
		ButtonViewCreator.createButton(type: .other("AC"),
									   tapHandler: actionClean)

	/// Is user typing number
	private var userInTheMiddleOfTyping = false

	private var calculatorEngine = CalculatorEngine()

	private let decimalSeparator = Formatter.decimal.decimalSeparator ?? ","

	private var displayValue: Double? {
		get {
			guard let text = resultView.text else { return nil }
			var value: Double?
			if text.contains("e") {
				value = Formatter.scientific.number(from: text) as? Double
			}
			else {
				value = Formatter.decimal.number(from: text) as? Double
			}
			return value
		}
		set {
			guard let value = newValue else { return }
			if String(value).count < 12 {
				resultView.text = value.decimalFormatted
			}
			else {
				resultView.text = value.scientificFormatted
			}
		}
	}

	private var displayResult: CalculatorEngine.Response = .success(0) {

		didSet {

			switch displayResult {
			case .failure: resultView.text = "Ошибка"
			case .success(nil): displayValue = 0
			case .success(let result): displayValue = result
			}
		}
	}

	private enum ClearType
	{
		case clean, allClean

		mutating func toggle() {
			switch self {
			case .clean: self = .allClean
			case .allClean: self = .clean
			}
		}
	}

	private var clearType: ClearType = .allClean {
		didSet {
			switch clearType {
			case .clean: self.clearButtonView.setTitle("C")
			case .allClean: self.clearButtonView.setTitle("AC")
			}
		}
	}

	private var lastOperatorButtonView: ButtonView?

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		setConstraints()
		addSwipeGestureRecognizer()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		.lightContent
	}

	// MARK: Private methods
	private func setConstraints() {
		var selfView: UILayoutGuide
		if #available(iOS 11.0, *) {
			selfView = self.view.safeAreaLayoutGuide
		}
		else {
			selfView = self.view.layoutMarginsGuide
		}
		resultView.snp.makeConstraints { maker in
			maker.leading.equalTo(selfView).offset(16)
			maker.trailing.equalTo(selfView).offset(-16)
			maker.height.equalTo(113)
		}
		buttonsAreaView.snp.makeConstraints { maker in
			maker.leading.equalToSuperview().offset(8)
			maker.trailing.equalToSuperview().offset(-8)
			maker.bottom.equalTo(selfView).offset(-8)
			maker.top.equalTo(resultView.snp.bottom).offset(8)
			maker.height.equalTo(buttonsAreaView.snp.width).multipliedBy(CGFloat(countOfRows) / CGFloat(countOfColumns))
		}
	}

	private func addSwipeGestureRecognizer() {
		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(actionBackspace))
		swipeGestureRecognizer.direction = [.left, .right]
		resultView.addGestureRecognizer(swipeGestureRecognizer)
	}

	private func setup() {
		view.backgroundColor = AppSetting.Color.background
		self.view.addSubview(resultView)
		self.view.addSubview(buttonsAreaView)
	}
}

// MARK: - Actions
extension CalculatorViewController
{

	private func actionTouchDigit(_ sender: ButtonView) {
		lastOperatorButtonView?.deselect()
		clearType = .clean
		let digit = sender.title
		let currentText = resultView.text ?? ""
		if userInTheMiddleOfTyping {
			guard digit != decimalSeparator || currentText.contains(decimalSeparator) == false else { return }
			guard digit != decimalSeparator else {
				resultView.text = currentText + digit
				return
			}
			let countOfDigits = currentText.filter {
				String($0) != decimalSeparator && String($0) != " "
			}.count
			guard countOfDigits < 9 else { return }
			let displayValue = (currentText + digit).filter { $0 != " " }
			guard let resultNumber = Formatter.scientific.number(from: displayValue) as? Double else { return }
			resultView.text = resultNumber.decimalFormatted
		}
		else {
			if digit == decimalSeparator {
				resultView.text = "0" + digit
			}
			else {
				resultView.text = digit
			}
			userInTheMiddleOfTyping = true
		}
		if let value = displayValue {
			calculatorEngine.setOperand(value)
		}
	}

	private func actionPerformOperation(_ sender: ButtonView) {
		guard let symbol = CalculatorEngine.Operator(rawValue: sender.title) else {
			return
		}
		//selectedButtonView

		clearType = .clean

		if userInTheMiddleOfTyping {
			userInTheMiddleOfTyping = false
		}

		switch symbol {
		case .divide, .multiple, .minus, .plus:
			lastOperatorButtonView?.deselect()
			sender.select()
			lastOperatorButtonView = sender
		case .magnitude:
			userInTheMiddleOfTyping = true
		case .equals:
			lastOperatorButtonView?.deselect()
			lastOperatorButtonView = nil
		default: break
		}

		calculatorEngine.performOperation(with: symbol) { result in
			self.displayResult = result
		}
	}

	private func actionClean(_ sender: ButtonView) {
		switch clearType {
		case .clean:
			calculatorEngine.clean()
			clearType = .allClean
			lastOperatorButtonView?.select()
		case .allClean:
			calculatorEngine.allClean()
			lastOperatorButtonView?.deselect()
			lastOperatorButtonView = nil
		}
		resultView.text = "0"
		userInTheMiddleOfTyping = false
	}

	@objc private func actionBackspace() {
		guard userInTheMiddleOfTyping, let text = resultView.text, text.isEmpty == false else { return }
		let newText = String(text.dropLast())
		resultView.text = newText
		if newText.isEmpty {
			displayValue = 0
			userInTheMiddleOfTyping = false
		}
	}
}
