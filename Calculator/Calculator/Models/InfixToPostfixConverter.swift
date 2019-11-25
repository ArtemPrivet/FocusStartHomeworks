//
//  InfixToPostfixConverter.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 24.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

enum InfixToPostfixConverter
{
	typealias OperationStack = CalculatorEngine.OperationStack

	private typealias Operator = CalculatorEngine.Operator
	private typealias Action = () -> Void

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

		func choosingAction(incomingOperator operator: Operator?) throws -> Action? {

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
