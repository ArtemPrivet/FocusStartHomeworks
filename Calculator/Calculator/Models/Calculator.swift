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
	// MARK: - Private Properies
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
	private var lastResult: Double?
	private var waitingBinaryOperation: WaitingBinaryOperation? // отложенная операция
	private var result: Double? { accumulatedValue } // результат вычислений операции
	private var resultIsWaiting: Bool { waitingBinaryOperation != nil }
	private var operationStack = [ExpressionBody]()

	private var currentOperationSign: String? {
		// знак последней операции, которая пришла от юзера
		didSet(newSign) {
			if let sign = newSign {
				// юзер изменил знак операции, меняем его в отложенной операции
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

	// MARK: Internal Properties
	var hasLastResult: Bool { lastResult != nil }

	// MARK: Internal Methods
	mutating func setOperand(_ operand: Double) {
		if operationStack.isEmpty {
			operationStack.append(ExpressionBody.operand(operand))
		}
		else {
			guard let lastItem = operationStack.last else { return }
			switch lastItem {
			case .operation: operationStack.append(ExpressionBody.operand(operand))
			default: break
			}
		}
	}

	mutating func setOperation(_ symbol: String) {
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

	mutating func evaluate() -> ( result: Double?, isWaiting: Bool) {
		// Nested Function
		func accumulateOperand(_ operand: Double) {
			accumulatedValue = operand
		}

		// Body
		guard operationStack.isEmpty == false else { return (nil, false) }

		for existOperation in operationStack {
			switch existOperation {
			case .operand(let operand):
				accumulateOperand(operand)
			case .operation(let operation):
				performOperation(operation)
			}
		}

		lastResult = result

		return (result, resultIsWaiting)
	}

	mutating func allClear() {
		operationStack = []
		waitingBinaryOperation = nil
		accumulatedValue = nil
		currentOperationSign = nil
		lastResult = nil
	}
}

// MARK: - Private Structs and Enums
private extension Calculator
{
	private enum OperationType
	{
		case unary((Double) -> Double, String) 			 // унарная
		case binary((Double, Double) -> Double, String) // бинарная
		case equals 								   // равно
	}

	private enum ExpressionBody
	{
		case operand(Double)    // число (операнд)
		case operation(String) // математическая операция
	}

	private struct WaitingBinaryOperation
	{
		var function: (Double, Double) -> Double // функция применяемая к операндам
		let functionSign: String 					// знак операции
		let firstOperand: Double 			   // первый операнд

		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}
}

// MARK: - Private Methods
private extension Calculator
{
	private mutating func performWaitingBinaryOperation() {
		if let operation = waitingBinaryOperation,
			let value = accumulatedValue {
			accumulatedValue = operation.perform(with: value)
			waitingBinaryOperation = nil
			// считаем все выражение
			cleanAfterPercantage()
			accumulatedValue = expressionValue()
		}
	}

	private mutating func performOperation(_ symbol: String) {
		guard let operation = operations[symbol] else { return }

		switch operation {
		case .unary(let operationFunction, let sign):
			if let notEmptyValue = accumulatedValue {
				if sign == Sign.percent {
					if let previosOperand = waitingBinaryOperation?.firstOperand {
						// найден предыдущий операнд, находим его %
						let percentageFromPreviosOperand = (previosOperand * notEmptyValue) / 100
						accumulatedValue = percentageFromPreviosOperand
					}
					else {
						// если перед числом не было операций то выполняем деление на 100
						accumulatedValue = operationFunction(notEmptyValue)
					}
				}
				else {
					// если это знак +/- то, меняем знак числа
					accumulatedValue = operationFunction(notEmptyValue)
				}
			}
		case .binary(let operationFunction, let signDescr):
			if let value = accumulatedValue {
				waitingBinaryOperation = WaitingBinaryOperation(
					function: operationFunction, functionSign: signDescr,
					firstOperand: value
				)
				accumulatedValue = nil
			}
		case .equals:
			performWaitingBinaryOperation()
		}
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

	///перебирает стек операций и творит польскую магию
	private mutating func expressionValue() -> Double {
		let rnpConverter = RPNConverter()
		var operationsArray = [String]()

		for item in operationStack {
			switch item {
			case .operand(let number):
				operationsArray.append(String(number))
			case .operation(let operationSign):
				if operationSign != Sign.equals {
					operationsArray.append(operationSign)
				}
			}
		}

		operationStack.removeAll()

		let rpnStringArray = rnpConverter.getRPNFrom(inputExpressionsArray: operationsArray)

		return rnpConverter.getDoubleFromRPN(expressionInArrayFormat: rpnStringArray)
	}
}
