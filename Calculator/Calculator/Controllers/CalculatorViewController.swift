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
	private var canDeleteOnlySeconInput = true
	private var equalWasUsed = false
	private var operatorWasUsed = false
	private var isGetingResult = false

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
			if button.identifier == nil {
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
		if operatorWasUsed == false {
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
	}
	@objc func numberButtonTapped(_ sender: CalculatorButton) {
		//Для того чтобы при вводе вороге числа можно было стереть только его
		if operatorWasUsed == true {
			canDeleteOnlySeconInput = true
		}
		//Если есть символ в кнопке
		guard let senderText = sender.titleLabel?.text else { return }
		//если есть текст в строке
		guard var resultLabelText = calculatorView.resultLabel.text else { return }
		//Если количство цифр не превысело максимума для ввода
		let clearResultLabelText = resultLabelText.filter("+0123456789.".contains)
		guard clearResultLabelText.count < 9 else { return }
		//Если получен результат и пользователь решил ввести новое выражение
		if equalWasUsed == true {
			canDeleteOnlySeconInput = false
			ACButtonTapped()
		}
		//если нажали запятую а она уже есть
		if senderText == "," && resultLabelText.contains(",") {
			return
		}
		//если прошлое нажатие было на оператор или нажали цифру когда лейбл был с дефолтным 0 или была ошибка
		if (resultLabelText == "0" && senderText != ",") || operatorWasUsed == true || resultLabelText == "Ошибка" {
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
		formatter.groupingSeparator = formatter.locale.groupingSeparator
	}
	private func updateLabel(value: String) {
		if value == "Ошибка" {
			calculatorView.resultLabel.text = value
		}
		let fixedValue = value
			.replacingOccurrences(of: ".", with: ",")
			.filter("0123456789,.-".contains)
		if fixedValue.contains(",") == false && fixedValue != "-0" && fixedValue != "Ошибка" {
			guard let nuberValue = formatter.number(from: fixedValue) else { return }
			calculatorView.resultLabel.text = formatter.string(from: nuberValue)
		}
		else{
			calculatorView.resultLabel.text = fixedValue
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
		//если в числе уже есть -
		if userInput.contains("-") == true {
			//удаляем его
			userInput.removeFirst()
			//если в выражении уже есть число
			if equalWasUsed == true {
				//заменяем его
				expression.removeLast()
				expression.append(userInput)
				print("After adding \(userInput)")
				print(expression)
			}
		}
			//если в числе еще нет -
		else {
			//вставляем его
			userInput.insert("-", at: userInput.startIndex)
			//если в выражении уже есть число
			if equalWasUsed == true {
				expression.removeLast()
				//заменяем
				expression.append(userInput)
				print("After adding \(userInput)")
				print(expression)
			}
		}
		updateLabel(value: userInput)
	}
	private func ACButtonTapped() {
		//Если необходимо отчистить только ввод второго числа
		if canDeleteOnlySeconInput == true {
			canDeleteOnlySeconInput = false
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
		guard let oper = sender.identifier else { return }
		//Если мы в выражении не использовали =
		if equalWasUsed == false {
			//Если можно заменить оператор - заменяем
			if let last = expression.last, operatorWasUsed == true {
				if calculator.isOperator(symbol: last) == true && oper != "="{
					expression.removeLast()
					expression.append(oper)
					return
				}
			}
			//добавим число к выражению
			expression.append(userInput)
		}
		operatorWasUsed = true
		switch oper{
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
		if oper != "=" {
			expression.append(oper)
			print("After adding \(oper)")
			print(expression)
		}
		equalWasUsed = false
	}
	private func calculatePercent() {
		expression.append("%")
		print("After adding %")
		print(expression)
		guard let value = expression.first else { return }
		if calculator.isOperator(symbol: value) == false {
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
			userInput = fixedresult
			expression.append(userInput)
			updateLabel(value: fixedresult)
			//Чтоб 2 раза не добавлять одинаковое число
			equalWasUsed = true
		}
	}
	private func solveAndShow() {
		//Теперь при нажатии АС удалится все выражение
		canDeleteOnlySeconInput = false
		//считаем
		let result = calculator.solve(input: expression)
		//проверим что получилось инт или дабл
		//По возможности округляем
		let fixedResult = checkResult(result)
		expression = []
		if fixedResult != "Ошибка" {
			expression.append(fixedResult)
			print("After adding \(fixedResult)")
			print(expression)
		}
		userInput = fixedResult
		updateLabel(value: fixedResult)
	}
	func checkResult(_ value: Double) -> String {
		if value.isInfinite {
			return "Ошибка"
		}
		let isInteger = floor(value)
		if isInteger == value {
			return String(Int(value))
		}
		return  String(value)
	}
}
