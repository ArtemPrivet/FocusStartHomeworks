//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.

import UIKit

final class CalculatorViewController: UIViewController
{
	private let calculatorView = CalculatorView()
	private let formatter = NumberFormatter()
	private let calculator = Calculator()
	private var userInput = "0"
	private var expression = [String]()
	private var canDeleteOnlySecondInput = true
	private var equalWasUsed = false
	private var operatorWasUsed = false
	private let errorMessage = "Ошибка"

	override func viewDidLoad() {
		super.viewDidLoad()
		addTargets()
		configureFormatter()
		addGestureRecognizerForLabel()
	}
	override func loadView() {
		view = calculatorView
	}
	private func addTargets() {
		calculatorView.buttons.forEach { button in
			if button.type == .digit {
				button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
			}
			else {
				button.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
			}
		}
	}
	private func addGestureRecognizerForLabel() {
		let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedOnLabel))
		swipe.direction = [.left, .right]
		calculatorView.resultLabel.addGestureRecognizer(swipe)
	}
	@objc private func swipedOnLabel(_ sender: UILabel) {
		//Если в лейбле не результат вычислений
		guard operatorWasUsed == true else { return }
		let oldUserInput = userInput
		if userInput.count > 1 {
			userInput.removeLast()
		}
		else {
			userInput = "0"
		}
		if expression.isEmpty == false {
			for index in 0..<expression.count - 1 where expression[index] == oldUserInput {
				expression[index] = userInput
			}
		}
		updateLabel(value: userInput)
	}
	@objc func numberButtonTapped(_ sender: CalculatorButton) {
		//Для того чтобы при вводе вороге числа можно было стереть только его
		if operatorWasUsed == true {
			canDeleteOnlySecondInput = true
		}
		//Если есть символ в кнопке
		guard let senderText = sender.titleLabel?.text else { return }
		//если есть текст в строке
		guard var resultLabelText = calculatorView.resultLabel.text else { return }
		//Если количство цифр не превысело максимума для ввода
		let clearResultLabelText = resultLabelText.filter("0123456789.".contains)
		guard clearResultLabelText.count < 9 || operatorWasUsed == true else  { return }
		//Если получен результат и пользователь решил ввести новое выражение
		if equalWasUsed == true {
			canDeleteOnlySecondInput = false
			ACButtonTapped()
		}
		//если нажали запятую а она уже есть
		if senderText == "," && resultLabelText.contains(",") {
			return
		}
		//если прошлое нажатие было на оператор или нажали цифру когда лейбл был с дефолтным 0 или была ошибка
		if (resultLabelText == "0" && senderText != ",") || operatorWasUsed == true || resultLabelText == errorMessage {
			if senderText == "," {
				resultLabelText = "0" + senderText
			}
			else {
				resultLabelText = senderText
			}
		}
		//если в лейбле уже что то есть
		else {
			resultLabelText += senderText
		}
		//снимем активацию с кнопки для того чтобы можно было менять операторы при вводе
		operatorWasUsed = false
		//выведем результат
		updateLabel(value: resultLabelText)
		//сохраним введеное число
		setUserInput(value: resultLabelText)
		switchACTitle()
	}
	private func configureFormatter() {
		formatter.numberStyle = .decimal
		formatter.locale = Locale(identifier: "FR_fr")
		formatter.groupingSeparator = " "
		formatter.maximumFractionDigits = 8
	}
	private func updateLabel(value: String?) {
		if let value = value {
			let fixedValue = value
				.replacingOccurrences(of: ".", with: ",")
				.filter("0123456789,.-".contains)
			if value.contains(",") == false && fixedValue != "-0" && fixedValue != errorMessage && value.contains("e") == false {
				//ему нужна ток запятая
				guard let numberValue = formatter.number(from: fixedValue) else { return }
				calculatorView.resultLabel.text = formatter.string(from: numberValue)
			}
			else{
				calculatorView.resultLabel.text = value
			}
		}
		else {
			calculatorView.resultLabel.text = errorMessage
		}
	}
	private func setUserInput(value: String) {
		userInput = value
			.filter("0123456789,-".contains)
			.replacingOccurrences(of: ",", with: ".")
	}
	@objc func operatorButtonTapped(_ sender: CalculatorButton) {
		switch sender.identifier {
		case "AC":
			ACButtonTapped()
		case "+-":
			negativeButtonTapped()
		case "=":
			makeOperation(sender)
			equalWasUsed = true
		default:
			makeOperation(sender)
		}
	}
	private func negativeButtonTapped() {
		if userInput.contains("-") == true {
			userInput.removeFirst()
		}
		else {
			userInput.insert("-", at: userInput.startIndex)
		}
		if expression.isEmpty == false {
			expression.removeLast()
		}
		expression.append(userInput)
		updateLabel(value: userInput)
	}
	private func ACButtonTapped() {
		//Если необходимо отчистить только ввод второго числа
		if canDeleteOnlySecondInput == true {
			canDeleteOnlySecondInput = false
		}
		//если необходимо отчистить еще и предыдущий результат
		else {
			expression = []
		}
		userInput = "0"
		updateLabel(value: userInput)
		switchACTitle()
		equalWasUsed = false
	}
	private func switchACTitle() {
		let button = calculatorView.buttons[0]
		calculatorView.resultLabel.text != "0" ? button.setTitle("C", for: .normal) : button.setTitle("AC", for: .normal)
	}
	private func makeOperation(_ sender: CalculatorButton) {
		guard let operation = sender.identifier else { return }
		//Если мы в выражении не использовали =
		if equalWasUsed == false {
			//Если можно заменить оператор - заменяем
			if let last = expression.last, operatorWasUsed == true {
				if calculator.isOperator(symbol: last) == true && operation != "="{
					expression.removeLast()
					expression.append(operation)
					return
				}
			}
			//добавим число к выражению
			expression.append(userInput)
		}
		operatorWasUsed = true
		switch operation{
		case "+", "-", "=":
			//пытаемся решить
			solveAndShow()
		case "*", "/":
			//если есть операция более высокого приоритета (* /) - пытаемся решить
			if expression.contains(where: { "*/".contains($0) }) {
				solveAndShow()
			}
		case "%":
			//в выражении вида a + b% заменяем b% на значение b% от а
			calculatePercent()
			return
		default:
			break
		}
		//Не добавляем оператор = к выражению
		if operation != "=" {
			expression.append(operation)
		}
		equalWasUsed = false
	}
	private func calculatePercent() {
		expression.append("%")
		guard let value = expression.first else { return }
		guard calculator.isOperator(symbol: value) == false else { return }
		let percent = expression.removeLast()
		let percentValue = expression.removeLast()
		var  subExpression = [String]()
		//Если ввели a% то взять a% от 1
		if value == percentValue {
			subExpression = ["1", percentValue, percent]
		}
		else {
			subExpression = [value, percentValue, percent]
		}
		let result = calculator.solve(input: subExpression)
		let fixedresult = checkResult(result)
		userInput = fixedresult ?? "0"
		expression.append(userInput)
		updateLabel(value: fixedresult)
		//Чтоб 2 раза не добавлять одинаковое число
		equalWasUsed = true
	}
	private func solveAndShow() {
		//Теперь при нажатии АС удалится все выражение
		canDeleteOnlySecondInput = false
		//считаем
		let result = calculator.solve(input: expression)
		//проверим что получилось инт или дабл
		//По возможности округляем
		let fixedResult = checkResult(result)
		expression = []
		if let fixedResult = checkResult(result) {
			expression.append(fixedResult)
			userInput = fixedResult
		}
		else {
			userInput = "0"
		}
		updateLabel(value: fixedResult)
	}
	func checkResult(_ value: Double) -> String? {
		guard value.isInfinite != true else { return nil }
		return String(format: "%.8f", value)
	}
}
