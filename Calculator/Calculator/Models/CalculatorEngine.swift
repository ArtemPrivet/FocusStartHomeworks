//
//  Calculator.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

// swiftlint:disable strict_fileprivate
// swiftlint:disable file_length

import Foundation

struct CalculatorEngine
{
	/// Операции
	/// - case percentOperation - (унарная операцияб бинарная операция)
	/// - case unaryOperation - (операция, валидация)
	/// - case binaryOperation - (операция, валидация, приоритет)
	/// - case equals - операция "равно"
	fileprivate enum Operation
	{
		case percentOperation(UnaryOperation, BinaryOperation)
		case unaryOperation(UnaryOperation, ValidatorUnaryOperation?)
		case binaryOperation(BinaryOperation, ValidatorBinaryOperation?, Int)
		case equals
	}

	fileprivate enum OperationStack: CustomStringConvertible
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

		fileprivate func operation(from operations: [Self: Operation]) -> Operation? {
			operations[self]
		}
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
	private var countOfEquals = 0

	private var operations: [Operator: Operation] = [
		.magnitude: .unaryOperation({ -$0 }, nil),
		.multiple: .binaryOperation(*, nil, 1),
		.divide: .binaryOperation(/, { $1 == 0.0 ? .error(message: "деление на ноль") : nil }, 1),
		.plus: .binaryOperation(+, nil, 0),
		.minus: .binaryOperation(-, nil, 0),
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
	}

	mutating func allClean() {
		clean()
		reset()
	}

	// swiftlint:disable cyclomatic_complexity
	// swiftlint:disable:next function_body_length
	mutating func performOperation(with symbol: Operator, completion: (Response) -> Void) {

		var error: CalculateError?

		func evaluate(_ completion: (Response) -> Void) {
			do {
				accumulator = try evaluateUsingPostfixNotation(infixArray)
			}
			catch CalculateError.error(message: let message) {
				completion(.failure(.error(message: message)))
				return
			}
			catch {
				completion(.failure(.error(message: "ERROR")))
				return
			}
			completion(.success(accumulator))
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
				if countOfEquals > 0 {
					reset()
					infixArray.append(.operand(accumulator))
					countOfEquals = 0
					performOperation(with: symbol, completion: completion) // РЕКУРСИЯ
					return
				}
			}

			guard
				let lastOperation = `operator`.operation(from: operations),
				let newOperation = symbol.operation(from: operations) else {

					completion(.failure(.error(message: "ERROR")))
					return
			}

			switch (lastOperation, newOperation) {

			case (_, let .unaryOperation(function, validator)):
				error = validator?(0)
				accumulator = function(0)
				setOperand(accumulator)

			case (_, .binaryOperation):
				infixArray.removeLast()
				performOperation(with: symbol, completion: completion) // РЕКУРСИЯ
				return

			case (_, .equals):
				countOfEquals += 1
				infixArray.append(.operand(lastOperand))
				evaluate(completion)
				reset()
				if countOfEquals > 0 {
					infixArray.append(.operand(accumulator))
					infixArray.append(.operator(`operator`))
				}
				return

			case (_, let .percentOperation(_, binaryFunction)):

				let previousOperationStack = infixArray[infixArray.endIndex - 2]

				guard case .operand(let operand) = previousOperationStack else {
					completion(.failure(.error(message: "ERROR")))
					return
				}

				let newInfixArray = infixArray[...(infixArray.endIndex - 2)]

				do {
					let resultBeforePercentOperator = try evaluateUsingPostfixNotation(Array(newInfixArray))
					accumulator = binaryFunction(resultBeforePercentOperator, operand)
					infixArray.append(.operand(accumulator))
				}
				catch CalculateError.error(message: let message) {
					completion(.failure(.error(message: message)))
					return
				}
				catch {
					completion(.failure(.error(message: "ERROR")))
					return
				}
			}
		}
		else {
			// В стэке послдний элемент - операнд
			guard let operation = symbol.operation(from: operations) else {

					completion(.failure(.error(message: "ERROR")))
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

						completion(.failure(.error(message: "ERROR")))
						return
				}

				if infixArray.count > 1 {

					let previousOperationStack = infixArray[infixArray.endIndex - 3]

					guard case .operand(let previousOperand) = previousOperationStack else {

						completion(.failure(.error(message: "ERROR")))
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
				print(infixArray)
				countOfEquals += 1
				let lastOperator = infixArray[infixArray.endIndex - 2]
				evaluate(completion)
				reset()
				if countOfEquals > 0 {
					infixArray.append(.operand(accumulator))
					infixArray.append(lastOperator)
				}
				return
			}
		}

		completion(.success(accumulator))
	}
	// swiftlint:enable function_body_length

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

					case let .binaryOperation(function, validator, _):
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

// MARK: - Infix to postfix alhorithm
fileprivate extension CalculatorEngine
{
	enum ScriptError: Error
	{
		case openBracket
		case closeBracket
	}

	// swiftlint:disable:next function_body_length
	static func convertInfixToPostfixNotation(input array: [OperationStack]) throws -> Queue<OperationStack> {
		var array = array
		var stack = Stack<OperationStack>()
		var postfixNotationArray = Queue<OperationStack>()

		func popImfixToPostfixNotation() {
			postfixNotationArray.push(array.removeFirst())
		}

		func popImfixNotationToStack() {
			stack.push(array.removeFirst())
		}

		func popStackToPostfixNotation() {
			guard let item = stack.pop() else {
				assertionFailure("Stack is Empty")
				return
			}
			postfixNotationArray.push(item)
		}

		func removeFromStack() {
			stack.pop()
		}

		func removeFromInfixNotation() {
			array.removeFirst()
		}

		func removeFromStackAndInfixNotation() {
			removeFromStack()
			removeFromInfixNotation()
		}

		func choosingAction(incomingOperator operator: Operator?) throws -> (() -> Void)? {

			guard let `operator` = `operator` else {

				guard let top = stack.top else { return nil }

				switch top {

				case .operator(let symbol) where symbol == .openBracket: throw ScriptError.openBracket

				case .operator: return popStackToPostfixNotation

				case .operand: break
				}

				return nil
			}

			switch `operator` {

			case .plus, .minus:
				guard let top = stack.top else { return popImfixNotationToStack }

				switch top {

				case .operator(let symbol) where symbol == .openBracket: return popImfixNotationToStack

				case .operator: return popStackToPostfixNotation

				case .operand: break
				}

			case .multiple, .divide:
				if case .operator(let symbol) = stack.top, (symbol == .multiple || symbol == .divide) {
					return popStackToPostfixNotation
				}
				else {
					return popImfixNotationToStack
				}

			case .openBracket:
				return popImfixNotationToStack

			case .closeBracket:
				guard let top = stack.top else {
					throw ScriptError.closeBracket
				}

				switch top {

				case .operator(let symbol) where symbol == .openBracket: return removeFromStackAndInfixNotation

				case .operator: return popStackToPostfixNotation

				case .operand: break
				}

			case .equals, .magnitude, .percent:
				break
			}
			return nil
		}

		while let item = array.first {
			switch item {
			case .operand:
				popImfixToPostfixNotation()
			case .operator(let symbol):
				do {
					let action = try choosingAction(incomingOperator: symbol)
					action?()
				}
				catch {
					throw error
				}
			}
		}

		while stack.isEmpty == false {
			let action = try choosingAction(incomingOperator: nil)
			action?()
		}

		return postfixNotationArray
	}
}

// MARK: - [OperationStack]
private extension Array where Element == CalculatorEngine.OperationStack
{
	func convertToPostfix() throws -> Queue<Element> {
		try CalculatorEngine.convertInfixToPostfixNotation(input: self)
	}
}

// MARK: - Extension ArraySlice<OperationStack>
private extension ArraySlice where Element == CalculatorEngine.OperationStack
{
	func convertToPostfix() throws -> Queue<Element> {
		try CalculatorEngine.convertInfixToPostfixNotation(input: Array(self))
	}
}
