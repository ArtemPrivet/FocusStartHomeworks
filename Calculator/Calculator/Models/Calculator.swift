//
//  Calculator.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 18.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct Calculator
{
	// MARK: - PRIVATE STRUCTS
	private enum OperationType
	{
		// типы операций
		case unary((Double) -> Double, String) 					 // унарная
		case binary((Double, Double) -> Double, String) // бинарная
		case equals 								   // равно
	}

	private enum ExpressionBody
	{
		// тело выражения
		case operand(Double)    // число (операнд)
		case operation(String) // математическая операция
		case variable(String) // для переменной типа % от числа
	}

	private struct WaitingBinaryOperation
	{
		var function: (Double, Double) -> Double // функция применяемая к операндам
		let funcSign: String 					// знак операции
		let firstOperand: Double 			   // первый операнд

		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}
	// MARK: - PRIVATE PROPERTIES
	private let operations: [String: OperationType] = [
		Sign.changeSign: .unary ({ -$0 }, Sign.changeSign),	//меняет знак операнда
		Sign.percent: .unary ({ $0 / 100 }, Sign.percent),	//процент от операнда
		Sign.divide: .binary ({ $0 / $1 }, Sign.divide),	//деление
		Sign.multiply: .binary ({ $0 * $1 }, Sign.multiply),	//умножение
		Sign.minus: .binary ({ $0 - $1 }, Sign.minus),	//вычитание
		Sign.plus: .binary ({ $0 + $1 }, Sign.plus),	//сложениt
		Sign.equals: .equals,	//равенство
	]

	private var accumulatedValue: Double? // запоминает операнды в отложенной операции

	private var currentOperationSign: String? {
		// знак последней операции, которая пришла от юзера
		didSet(newSign) {
			// юзер изменил знак операции, меняем его в отложенной операции
			if let sign = newSign {
				if waitingBinaryOperation != nil {
					guard let operation = operations[sign] else { return }
					switch operation {
					case .binary(let function, _):
						waitingBinaryOperation?.function = function
					default: break
					}
				}
			}
		}
	}

	private var waitingBinaryOperation: WaitingBinaryOperation? // отложенная операция

	private var result: Double? { return accumulatedValue } // результат вычислений операции

	private var lastResult: Double? {
		didSet(newValue) {
			print(newValue)
		}
	}

	private var resultIsWaiting: Bool { waitingBinaryOperation != nil }

	private var operationStack = [ExpressionBody]() {
		didSet {
//			guard let lastElement = operationStack.last else { return }
//
//			switch lastElement {
//			case .operand(let lastOperand):
//				if let accumValue = accumulatedValue {
//					if lastOperand == accumValue {
//						operationStack.removeLast()
//						accumulatedValue = nil
//					}
//				}
//			default: break
//			}
			print(operationStack)
		}
	}

	// MARK: INTERNAL METHODS
	mutating func setOperand(_ operand: Double) {
		if operationStack.isEmpty {
			operationStack.append(ExpressionBody.operand(operand))
		}
		else {
			guard let lastItem = operationStack.last else { return }
			switch lastItem {
			case .operand(let number):
				print(number)
			case .operation(let sign):
				if sign != Sign.allClear || sign != Sign.clear {
				operationStack.append(ExpressionBody.operand(operand))
				}
			default: break
			}
		}
	}

	mutating func setOperand(variable named: String) {
		operationStack.append(ExpressionBody.variable(named))
	}

	mutating func setOperation(_ symbol: String) {
		if symbol != Sign.allClear {
			guard let lastItem = operationStack.last else { return }
			switch lastItem {
			case .operation(let sign):
				switch sign {
				case Sign.divide, Sign.multiply, Sign.minus, Sign.plus, Sign.equals:
					// "Меняю знак операции если пользователь вдруг поменял знак при уже нажатом знаке, ожидаю второй операнд"
					currentOperationSign = symbol
					let lastIndex = operationStack.count - 1
					operationStack[lastIndex] = ExpressionBody.operation(symbol)
				default: break
				}
			default:
				// если впереди стоит операнд(число), то можно добавить новый знак операции
				operationStack.append(ExpressionBody.operation(symbol))
			}
		}
	}

	mutating func clear() {
		operationStack = []
		accumulatedValue = nil
		lastResult = nil
	}
}

// MARK: - CALC ENGINE
extension Calculator
{
	mutating func evaluate(using variables: [String: Double]? = nil) -> (
		result: Double?,
		isWaiting: Bool
		) {
			// NESTED FUNCTIONS
			func performWaitingBinaryOperation() {
				if let operation = waitingBinaryOperation,
					let value = accumulatedValue {
					accumulatedValue = operation.perform(with: value)
					waitingBinaryOperation = nil
					// считаем все выражение
					cleanAfterPercantage()
					accumulatedValue = expressionValue()
				}
			}

			func setOperand(_ operand: Double) {
				accumulatedValue = operand
			}

			func setOperand(variable named: String) {
				accumulatedValue = variables?[named] ?? 0
			}

			func performOperation(_ symbol: String) {
				guard let operation = operations[symbol] else { return }

				switch operation {
				case .unary(let operationFunction, let sign):
					if let notEmptyValue = accumulatedValue {
						if sign == Sign.percent {
							if let previosOperand = waitingBinaryOperation?.firstOperand {
								let percentageFromPreviosOperand = (previosOperand * notEmptyValue) / 100
								accumulatedValue = percentageFromPreviosOperand
							}
						}
						else {
							accumulatedValue = operationFunction(notEmptyValue)
						}
					}
				case .binary(let operationFunction, let signDescr):
					if let value = accumulatedValue {
						waitingBinaryOperation = WaitingBinaryOperation(
							function: operationFunction, funcSign: signDescr,
							firstOperand: value
						)
						accumulatedValue = nil
					}
				case .equals:
					performWaitingBinaryOperation()
				}
			}

			// FUNCTION BODY
			guard operationStack.isEmpty == false else { return (nil, false) }

			for existOperation in operationStack {
				switch existOperation {
				case .operand(let operand):
					setOperand(operand)
				case .operation(let operation):
					performOperation(operation)
				case .variable(let symbol):
					setOperand(variable: symbol)
				}
			}
			print(result)
			return (result, resultIsWaiting)
	}

	private mutating func cleanAfterPercantage() {
		for (index, element) in operationStack.enumerated() {
			switch element {
			case .operation(let sign):
				if sign == Sign.percent {
					operationStack.remove(at: index + 1)
				}
			default: break
			}
		}
	}

	private mutating func expressionValue() -> Double {
		var testArray = [String]()
		for item in operationStack {
			switch item {
			case .operand(let number):
				testArray.append(String(number))
			case .operation(let operationSign):
				if operationSign != Sign.equals {
				testArray.append(operationSign)
				}
			default:
				break
			}
		}

		let rpnEncoder = RPNEncoder(testArray)
		let rpnDecoder = RPNDecoder(expressionInArrayFormat: rpnEncoder.expressionsAsRPN)

		operationStack.removeAll()
		return rpnDecoder.double
	}
}
