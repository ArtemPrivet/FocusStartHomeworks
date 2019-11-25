//
//  Calculator.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

// swiftlint:disable strict_fileprivate

import Foundation

struct CalculatorEngine
{
	/// Операции
	/// - case percentOperation - (унарная операцияб бинарная операция)
	/// - case unaryOperation - (операция, валидация)
	/// - case binaryOperation - (операция, валидация)
	/// - case equals - операция "равно"
	fileprivate enum Operation
	{
		case percentOperation(UnaryOperation, BinaryOperation)
		case unaryOperation(UnaryOperation, ValidatorUnaryOperation?)
		case binaryOperation(BinaryOperation, ValidatorBinaryOperation?)
		case equals
	}

	enum OperationStack: CustomStringConvertible
	{
		case operand(Double)
		case `operator`(Operator)

		var description: String {
			switch self {
			case .operand(let operand): return "\(operand)"
			case .`operator`(let operation): return operation.rawValue
			}
		}
	}

	enum Operator: String, CustomStringConvertible
	{
		case plus = "+"
		case minus = "−"
		case divide = "÷"
		case multiple = "×"
		case openBracket = "("
		case closeBracket = ")"
		case magnitude = "⁺∕₋"
		case percent = "%"
		case equals = "="

		var description: String { rawValue }
	}

	enum CalculateError: Error
	{
		case error(message: String)

		var localizedDescription: String {
			switch self {
			case .error(message: let message): return message
			}
		}
	}

	typealias CalculateResult = Double
	typealias Response = Result<CalculateResult, CalculateError>

	fileprivate typealias UnaryOperation = (Double) -> Double
	fileprivate typealias BinaryOperation = (Double, Double) -> Double
	fileprivate typealias ValidatorUnaryOperation = ((Double) -> CalculateError?)
	fileprivate typealias ValidatorBinaryOperation = ((Double, Double) -> CalculateError?)

	// MARK: ... Private properties
	private typealias Operations = [Operation]

	private var accumulator: Double = 0
	private var infixArray = [OperationStack]()
	private var lastOperand: Double = 0
	private var equalsIsTapped = false

	private var operations: [Operator: Operation] = [
		.magnitude: .unaryOperation({ -$0 }, nil),
		.multiple: .binaryOperation(*, nil),
		.divide: .binaryOperation(/, { $1 == 0.0 ? .error(message: "деление на ноль") : nil }),
		.plus: .binaryOperation(+, nil),
		.minus: .binaryOperation(-, nil),
		.percent: .percentOperation({ $0 / 100 }, { $1 / 100 * $0 }),
		.equals: .equals,
	]

	// MARK: ... Internal metods
	/// Добавляет операнд
	/// - Parameter operand: операнд
	mutating func setOperand(_ operand: Double) {
		if case .operand = infixArray.last {
			infixArray.removeLast()
		}
		infixArray.append(.operand(operand))
		accumulator = operand
		lastOperand = accumulator
	}

	mutating func clean() {
		accumulator = 0
		equalsIsTapped = false
	}

	mutating func allClean() {
		clean()
		reset()
	}

	// swiftlint:disable:next function_body_length
	mutating func performOperation(with symbol: Operator, completion: ((Response) -> Void)? = nil) {

		var error: CalculateError?

		func evaluate(_ completion: ((Response) -> Void)?) {
			do {
				accumulator = try evaluateUsingPostfixNotation(infixArray)
			}
			catch CalculateError.error(message: let message) {
				completion?(.failure(.error(message: message)))
				return
			}
			catch {
				completion?(.failure(.error(message: "ERROR")))
				return
			}
			completion?(.success(accumulator))
		}

		if infixArray.isEmpty {
			setOperand(accumulator)
		}

		if case .operator(let `operator`) = infixArray.last {
			// В стэке послдний элемент - оператор
			switch symbol {
			case .equals:
				break
			default:
				guard equalsIsTapped else { break }
				reset()
				infixArray.append(.operand(accumulator))
				equalsIsTapped = false
				performOperation(with: symbol, completion: completion) // РЕКУРСИЯ
				return
			}

			guard
				let lastOperation = `operator`.operation(from: operations),
				let newOperation = symbol.operation(from: operations) else {

					completion?(.failure(.error(message: "ERROR")))
					return
			}

			switch (lastOperation, newOperation) {

			case (_, let .unaryOperation(function, _)):
				accumulator = function(0)
				setOperand(accumulator)

			case (_, .binaryOperation):
				infixArray.removeLast()
				performOperation(with: symbol, completion: completion) // РЕКУРСИЯ
				return

			case (_, .equals):
				equalsIsTapped = true
				infixArray.append(.operand(lastOperand))
				evaluate(completion)
				reset()
				infixArray.append(.operand(accumulator))
				infixArray.append(.operator(`operator`))
				return

			case (_, let .percentOperation(_, binaryFunction)):

				let previousOperationStack = infixArray[infixArray.endIndex - 2]

				guard case .operand(let operand) = previousOperationStack else {
					completion?(.failure(.error(message: "ERROR")))
					return
				}

				let newInfixArray = infixArray[...(infixArray.endIndex - 2)]

				do {
					let resultBeforePercentOperator = try evaluateUsingPostfixNotation(Array(newInfixArray))
					accumulator = binaryFunction(resultBeforePercentOperator, operand)
					infixArray.append(.operand(accumulator))
				}
				catch CalculateError.error(message: let message) {
					completion?(.failure(.error(message: message)))
					return
				}
				catch {
					completion?(.failure(.error(message: "ERROR")))
					return
				}
			}
		}
		else {
			// В стэке послдний элемент - операнд
			guard let operation = symbol.operation(from: operations) else {

					completion?(.failure(.error(message: "ERROR")))
					return
			}

			switch operation {

			case let .unaryOperation(function, validator):
				error = validator?(accumulator)
				accumulator = function(accumulator)
				infixArray.removeLast()
				infixArray.append(.operand(accumulator))

			case let .percentOperation(unaryFunction, binaryFunction):
				guard let operationStack = infixArray.last,
					case .operand(let operand) = operationStack else {

						completion?(.failure(.error(message: "ERROR")))
						return
				}

				if infixArray.count > 1 {

					let previousOperationStack = infixArray[infixArray.endIndex - 3]

					guard case .operand(let previousOperand) = previousOperationStack else {

						completion?(.failure(.error(message: "ERROR")))
						return
					}

					accumulator = binaryFunction(previousOperand, operand)
					infixArray.removeLast()
					infixArray.append(.operand(accumulator))
				}
				else {
					accumulator = unaryFunction(accumulator)
					infixArray.removeLast()
					infixArray.append(.operand(accumulator))
				}

			case .binaryOperation:
				evaluate(completion)
				infixArray.append(.operator(symbol))
				return

			case .equals:
				equalsIsTapped = true
				let lastOperator = infixArray[infixArray.endIndex - 2]
				evaluate(completion)
				reset()
				infixArray.append(.operand(accumulator))
				infixArray.append(lastOperator)
				return
			}
		}

		completion?(.success(accumulator))
	}
	// swiftlint:enable cyclomatic_complexity

	// MARK: ... Private metods
	private func evaluateUsingPostfixNotation(_ infixArray: [OperationStack]) throws -> Double {

		var error: CalculateError?
		var queue = Stack<Double>()

		do {
			var postfixQueue = try infixArray.convertToPostfix()

			while let top = postfixQueue.pop() {

				switch top {

				case .operand(let operand):
					queue.push(operand)

				case .operator(let `operator`):
					guard let operation = `operator`.operation(from: operations) else {
						throw CalculateError.error(message: "Not finde operation with \(top.description)")
					}

					switch operation {

					case let .binaryOperation(function, validator):
						guard let secondOperand = queue.pop(),
							let firstOperand = queue.pop() else {
								throw CalculateError.error(message: "Not finde operation operands")
						}

						error = validator?(firstOperand, secondOperand)
						queue.push(function(firstOperand, secondOperand))

					case .percentOperation, .unaryOperation, .equals:
						break
					}
				}
			}
		}
		catch {
			throw error
		}

		if let error = error {
			throw error
		}

		guard let accumulator = queue.pop() else {
			throw CalculateError.error(message: "Cannot evaluate postfix")
		}

		return accumulator
	}

	mutating private func reset() {
		infixArray.removeAll()
	}
}

// MARK: - Extension Operator
extension CalculatorEngine.Operator
{
	fileprivate func operation(from operations: [Self: CalculatorEngine.Operation]) -> CalculatorEngine.Operation? {
		operations[self]
	}
}
