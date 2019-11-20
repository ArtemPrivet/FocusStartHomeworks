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
	private enum Operation
	{
		case unary((Double) -> Double)
		case binary((Double, Double) -> Double)
		case equals
		case clear
		case allClear
	}

	private struct WaitingBinaryOperation
	{
		let function: (Double, Double) -> Double
		let firstOperand: Double

		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}

	private var waitingBinaryOperation: WaitingBinaryOperation?

	private let operations: [String: Operation] = [
//		"AC": .allClear,
//		"C": .clear,
		"⁺∕₋": .unary { -$0 },
		"%": .unary { $0 / 100 },
		"÷": .binary { $0 / $1 },
		"×": .binary { $0 * $1 },
		"−": .binary { $0 - $1 },
		"+": .binary { $0 + $1 },
		"=": .equals,
	]

	private var accumulatedValue: Double?

	var result: Double? {
		return accumulatedValue
	}

	 var resultIsWaiting: Bool {
		waitingBinaryOperation != nil
	}

	mutating func performCalculation(_ symbol: String) {
		guard let operation = operations[symbol] else { return }
		switch operation {
		case .unary(let perform):
			if let notEmptyStack = accumulatedValue {
				accumulatedValue = perform(notEmptyStack)
			}
		case .binary(let perform):
			if let value = accumulatedValue {
				waitingBinaryOperation = WaitingBinaryOperation(function: perform, firstOperand: value)
				accumulatedValue = nil
			}
		case .equals:
			performWaitingBinaryOperation()
		case .clear: break
		case .allClear: break
		}
	}

	private mutating func performWaitingBinaryOperation() {
		if let operation = waitingBinaryOperation,
		let value = accumulatedValue {
		accumulatedValue = operation.perform(with: value)
		waitingBinaryOperation = nil
		}
	}

	mutating func setOperand(_ operand: Double) {
		accumulatedValue = operand
	}
}
