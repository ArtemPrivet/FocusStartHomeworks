//  Calculator.swift
//  Calculator
//
//  Created by Максим Шалашников on 19.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

final class Calculator
{
	private var RPNInterpretation: [String] = []

	func solve(input: [String]) -> Double {
		RPNInterpretation = toRPN(inputArray: input)
		//print(RPNInterpretation)
		let result = calculate(rpn: RPNInterpretation)
		return result
	}
	//Получения польской нотации
	func toRPN(inputArray: [String]) -> [String] {
		var stack = [String]()
		var output = [String]()
		var mayUnary = true
		for item in inputArray {
			switch getOperatorPriority(calcOperator: item) {
			case -1:
				output.append(item)
				mayUnary = false
			default:
				var oper = item
				if mayUnary {
					oper.insert("u", at: oper.startIndex)
				}
				while let last = stack.last {
					if getOperatorPriority(calcOperator: last) >= getOperatorPriority(calcOperator: oper) {
						output.append(stack.removeLast())
					}
					else {
						break
					}
				}
				stack.append(oper)
				mayUnary = true
			}
		}
		while stack.last != nil {
			output.append(stack.removeLast())
		}
		return output
	}
	//Расчет выражения
	private func calculate(rpn: [String]) -> Double {
		var result = 0.0
		var temp = Stack<Double>() //стек для решения
		for symbol in rpn {
			if let number = Double(symbol) {
				temp.push(number)
			}
			else if isOperator(symbol: symbol) {
				if symbol.contains("u") {
					let number = temp.pop() ?? 0.0
					temp.push(-1 * number)
				}
				else {
					let secondNumber = temp.pop() ?? 0.0
					let firstNumber = temp.pop() ?? secondNumber
					result = solveExpression(oper: symbol, leftOperand: firstNumber, rightOperand: secondNumber)
					temp.push(result) //Результат вычисления записываем обратно в стек
				}
			}
		}
		if let finalResult = temp.peek {
			return finalResult
		}
		else {
			return 0.0
		}
	}
	// MARK: - Методы - помошники
	private func solveExpression(oper: String, leftOperand: Double, rightOperand: Double) -> Double {
		var result = 0.0
		switch oper {//И производим над ними действие, согласно оператору
		case "+":
			result = leftOperand + rightOperand
		case "-":
			result = leftOperand - rightOperand
		case "*":
			result = leftOperand * rightOperand
		case "/":
			result = leftOperand / rightOperand
		case "%":
			//result = leftOperand - (leftOperand * rightOperand) / 100
			result = rightOperand * leftOperand / 100
		default:
			break
		}
		return result
	}
	private func getOperatorPriority(calcOperator: String) -> Int {
		switch calcOperator {
		case "u-", "u+":
			return 3
		case "+", "-":
			return 1
		case "*", "/", "%":
			return 2
		default: // numbers
			return -1
		}
	}
	private func isDelimeter(character: Character) -> Bool {
		if character == " " || character == "=" {
			return true
		}
		return false
	}
	func isOperator(symbol: String) -> Bool {
		switch symbol {
		case "*", "/", "+", "-", "%", "u+", "u-":
			return true
		default:
			return false
		}
	}
}
