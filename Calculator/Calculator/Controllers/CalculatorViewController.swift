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
				.other(clearType.rawValue),
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
		self.types.map { rowOfType in
			rowOfType.reduce(into: [ButtonView?]()) { result, type in
				if case .other(let symbol, _) = type, symbol == clearType.rawValue {
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
		}
	}()

	private var countOfRows: Int { buttons.count }
	private var countOfColumns: Int { buttons.first?.count ?? 0 }

	private var resultView = ResultView(backgroundColor: AppSetting.Color.background,
										textColor: AppSetting.Color.lightText)

	private lazy var buttonsAreaView =
		ButtonsAreaView(buttons: buttons,
						grid: (countOfRows, countOfColumns),
						offset: 14,
						backgroundColor: AppSetting.Color.background)

	private lazy var clearButtonView =
		ButtonViewCreator.createButton(type: .other(clearType.rawValue),
									   tapHandler: actionClean)

	/// Is user typing number
	private var userInTheMiddleOfTyping = false

	private var calculatorEngine = CalculatorEngine()

	private let decimalSeparator = Formatter.decimal.decimalSeparator ?? ","

	private var displayValue: Double? {
		get { getResult() }
		set { displayResult(newValue) }
	}

	private var calculatorResult: CalculatorEngine.Response = .success(0) {
		didSet {
			switch calculatorResult {
			case .failure: resultView.text = "Ошибка"
			case .success(nil): displayValue = 0
			case .success(let result): displayValue = result
			}
		}
	}

	private enum ClearType: String
	{
		case clean = "C", allClean = "AC"

		mutating func toggle() {
			switch self {
			case .clean: self = .allClean
			case .allClean: self = .clean
			}
		}
	}

	private var clearType: ClearType = .allClean {
		didSet {
			self.clearButtonView.setTitle(clearType.rawValue)
		}
	}

	private var lastOperatorButtonView: ButtonView?

	private var countOfTappedEqual = 0

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
			let offset = ConstantOfConstraints.longOffset.rawValue
			maker.leading.equalTo(selfView).offset(offset)
			maker.trailing.equalTo(selfView).offset(-offset)
			maker.height.equalTo(ConstantOfConstraints.heightResult.rawValue)
		}
		buttonsAreaView.snp.makeConstraints { maker in
			let offset = ConstantOfConstraints.shortOffset.rawValue
			maker.leading.equalToSuperview().offset(offset)
			maker.trailing.equalToSuperview().offset(-offset)
			maker.bottom.equalTo(selfView).offset(-offset)
			maker.top.equalTo(resultView.snp.bottom).offset(offset)
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

	private func getResult() -> Double? {
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

	private func displayResult(_ value: Double?) {

		guard let value = value else { return }
		let maxLenghtOfValue = 12
		var resultValue = ""

		if String(value).count < maxLenghtOfValue {
			resultValue = value.decimalFormatted
		}
		else {
			resultValue = value.scientificFormatted
		}

		let animated = (countOfTappedEqual == 1 && resultView.text == resultValue)

		resultView.setText(resultValue, animated: animated)
	}
}

// MARK: - Actions
extension CalculatorViewController
{

	private func actionTouchDigit(_ sender: ButtonView) {

		lastOperatorButtonView?.deselect()

		let digit = sender.title
		let currentText = resultView.text ?? ""
		var countOfDigits: Int {
			currentText.filter {
				String($0) != decimalSeparator && String($0) != " "
			}.count
		}
		var stringValue: String {
			(currentText + digit).filter { $0 != " " }
		}

		if userInTheMiddleOfTyping {
			guard digit != decimalSeparator || currentText.contains(decimalSeparator) == false else { return }
			guard digit != decimalSeparator else {
				resultView.text = currentText + digit
				return
			}
			let maxCountOfDigits = 9
			guard countOfDigits < maxCountOfDigits else { return }
			displayValue = Double(stringValue)
		}
		else {
			countOfTappedEqual = 0
			guard digit != "0" || clearType != .allClean else { return }

			if digit == decimalSeparator {
				resultView.text = currentText + digit
			}
			else {
				resultView.text = digit
			}
			userInTheMiddleOfTyping = true
		}
		if let value = displayValue {
			calculatorEngine.setOperand(value)
		}

		clearType = .clean
	}

	private func actionPerformOperation(_ sender: ButtonView) {

		guard let symbol = CalculatorEngine.Operator(rawValue: sender.title) else {
			return
		}

		if userInTheMiddleOfTyping {
			userInTheMiddleOfTyping = false
		}

		switch symbol {
		case .divide, .multiple, .minus, .plus:
			countOfTappedEqual = 0
			lastOperatorButtonView?.deselect()
			sender.select()
			lastOperatorButtonView = sender
		case .magnitude:
			countOfTappedEqual = 0
			userInTheMiddleOfTyping = true
		case .equals:
			countOfTappedEqual += 1
			lastOperatorButtonView?.deselect()
			lastOperatorButtonView = nil
		default: break
		}

		calculatorEngine.performOperation(with: symbol) { result in
			self.calculatorResult = result
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
		displayValue = 0
		userInTheMiddleOfTyping = false
	}

	@objc private func actionBackspace() {
		guard userInTheMiddleOfTyping, let text = resultView.text, text.isEmpty == false else { return }
		let newText = String(text.dropLast())
		let stringValue = newText.filter { $0 != " " }
		displayValue = Double(stringValue)
		if newText.isEmpty {
			displayValue = 0
			userInTheMiddleOfTyping = false
		}
		if let value = displayValue {
			calculatorEngine.setOperand(value)
		}
	}
}

extension CalculatorViewController
{
	private enum ConstantOfConstraints: Int
	{
		case shortOffset = 8
		case longOffset = 16
		case heightResult = 113
	}
}
