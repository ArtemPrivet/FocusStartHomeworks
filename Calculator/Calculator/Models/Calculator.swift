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

	private enum OperationPriority: Int
	{
		case high = 2
		case low = 1
		case max = 3
	}

	private enum OperationType
	{
		case unary((Double) -> Double)
		case binary((Double, Double) -> Double, OperationPriority, String)
		case equals
	}

	private enum OperationBody: Equatable
	{
		case operand(Double)    // число (операнд)
		case operation(String) // математическая операция
		case variable(String) // для переменной типа % от числа
	}

	private struct WaitingBinaryOperation
	{
		var function: (Double, Double) -> Double
		let funcSign: String
		let firstOperand: Double

		let previousPriority: OperationPriority
		let priority: OperationPriority

		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}
	// MARK: - PRIVATE PROPERTIES
	private let operations: [String: OperationType] = [
		Sign.changeSign: .unary ({ -$0 }),
		Sign.percent: .unary ({ $0 / 100 }),
		Sign.divide: .binary ({ $0 / $1 }, .high, Sign.divide),
		Sign.multiply: .binary ({ $0 * $1 }, .high, Sign.multiply),
		Sign.minus: .binary ({ $0 - $1 }, .low, Sign.minus),
		Sign.plus: .binary ({ $0 + $1 }, .low, Sign.plus),
		Sign.equals: .equals,
	]

	private var accumulatedValue: Double?

	private var currentOperationSign: String? {
		didSet(newSign) {
			if let sign = newSign {
				if waitingBinaryOperation != nil {
					guard let operation = operations[sign] else { return }
					switch operation {
					case .binary(let function, _, _):
						waitingBinaryOperation?.function = function
					default: break
					}
				}
			}
		}
	}

	private var previousWaitingOperationPriority = OperationPriority.max
	private var waitingBinaryOperation: WaitingBinaryOperation?

	private var result: Double? { return accumulatedValue }

	private var lastResult: Double? {
		didSet(newValue) {
			print(newValue)
		}
	}

	private var resultIsWaiting: Bool { waitingBinaryOperation != nil }

	private var internalProgram = [OperationBody]() {
		didSet {
			print(internalProgram)
		}
	}

	// MARK: INTERNAL METHODS
	mutating func setOperand(_ operand: Double) {
		if internalProgram.isEmpty {
			internalProgram.append(OperationBody.operand(operand))
		}
		else {
			guard let lastItem = internalProgram.last else { return }
			switch lastItem {
			case .operand(let number):
				print(number)
			case .operation(let sign):
				if sign != Sign.allClear || sign != Sign.clear {
				internalProgram.append(OperationBody.operand(operand))
				}
			default: break
			}
		}
	}

	mutating func setOperand(variable named: String) {
		internalProgram.append(OperationBody.variable(named))
	}

	mutating func setOperation(_ symbol: String) {
		if symbol != Sign.allClear {
			guard let lastItem = internalProgram.last else { return }
			switch lastItem {
			case .operation(let sign):
				switch sign {
				case Sign.divide, Sign.multiply, Sign.minus, Sign.plus, Sign.equals:
					print("Меняю знак операции, ожидаю второй операнд")
					currentOperationSign = symbol
					let lastIndex = internalProgram.count - 1
					internalProgram[lastIndex] = OperationBody.operation(symbol)
				default: break
				}
			default:
				internalProgram.append(OperationBody.operation(symbol))
			}
		}
	}

	mutating func clear() {
		internalProgram = []
		accumulatedValue = nil
		lastResult = nil
	}

	mutating func undo() {
		if internalProgram.isEmpty == false {
			internalProgram = Array(internalProgram.dropLast())
		}
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
					lastResult = accumulatedValue
					previousWaitingOperationPriority = operation.priority
					waitingBinaryOperation = nil
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
				case .unary(let operationFunction):
					if let notEmptyValue = accumulatedValue {
						accumulatedValue = operationFunction(notEmptyValue)
					}
				case .binary(let operationFunction, let priority, let signDescr):
					if let value = accumulatedValue {
						waitingBinaryOperation = WaitingBinaryOperation(
							function: operationFunction, funcSign: signDescr,
							firstOperand: value,
							previousPriority: previousWaitingOperationPriority,
							priority: priority
						)
						accumulatedValue = nil
					}
				case .equals:
					performWaitingBinaryOperation()
				}
			}

			// FUNCTION BODY
			guard internalProgram.isEmpty == false else { return (nil, false) }

			for existOperation in internalProgram {
				switch existOperation {
				case .operand(let operand):
					setOperand(operand)
				case .operation(let operation):
//					currentOperationSign = operation
					performOperation(operation)
				case .variable(let symbol):
					setOperand(variable: symbol)
				}
			}

			return (result, resultIsWaiting)
	}
}
