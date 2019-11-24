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
		RPNInterpretation = toReversePolishNotation(inputArray: input)
		//print(RPNInterpretation)
		let result = calculate(rpn: RPNInterpretation)
		return result
	}
	//Получениe польской нотации
	func toReversePolishNotation(inputArray: [String]) -> [String] {
		var stack = [String]()
		var output = [String]()
		var mayUnary = true
		for item in inputArray {
			switch getOperatorPriority(calcOperator: item) {
			case .lowPriority:
				output.append(item)
				mayUnary = false
			default:
				var oper = item
				if mayUnary {
					oper.insert("u", at: oper.startIndex)
				}
				while let last = stack.last {
					if getOperatorPriority(calcOperator: last).rawValue >= getOperatorPriority(calcOperator: oper).rawValue {
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
					result = solveExpression(operation: symbol, leftOperand: firstNumber, rightOperand: secondNumber)
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
	private func solveExpression(operation: String, leftOperand: Double, rightOperand: Double) -> Double {
		var result = 0.0
		switch operation {
		case "+":
			result = leftOperand + rightOperand
		case "-":
			result = leftOperand - rightOperand
		case "*":
			result = leftOperand * rightOperand
		case "/":
			result = leftOperand / rightOperand
		case "%":
			result = rightOperand * leftOperand / 100
		default:
			break
		}
		return result
	}
	private func getOperatorPriority(calcOperator: String) -> OperationPriority {
		switch calcOperator {
		case "u-", "u+":
			return .highestPriority
		case "+", "-":
			return .mediumPriority
		case "*", "/", "%":
			return .highPriority
		default: // numbers
			return .lowPriority
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
