//
//  LogicOperations.swift
//  Calculator
//
//  Created by Igor Shelginskiy on 11/17/19.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct LogicOperation
{
	private var accumulator: Double?

	private enum Operation
	{
		case constant(Double)
		case unaryOperation((Double) -> Double)
		case binaryOperation((Double, Double) -> Double)
		case equals
	}

	private var operations: [String: Operation] = [
		"⁺∕₋": Operation.unaryOperation{ -$0 },
		"×": Operation.binaryOperation(*),
		"+": Operation.binaryOperation(+),
		"-": Operation.binaryOperation{ $0 - $1 },
		"÷": Operation.binaryOperation{ $0 / $1 },
		"=": Operation.equals,
		"AC": Operation.constant(0),
		"%": Operation.binaryOperation{ ( $0 / 100 ) * $1 },
	]

	mutating func performOperation(_ symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
			case .constant(let value):
				accumulator = value
			case .unaryOperation(let function):
				if let accum = accumulator {
					accumulator = function(accum)
				}
			case .binaryOperation(let function):
				if let accum = accumulator {
					pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accum)
					accumulator = nil
				}
			case .equals:
				performPendingBinaryOperation()
			}
		}
	}

	private mutating func performPendingBinaryOperation() {
		if let pendOper = pendingBinaryOperation, let accum = accumulator {
			accumulator = pendOper.perform(with: accum)
			pendingBinaryOperation = nil
		}
	}

	private var pendingBinaryOperation: PendingBinaryOperation?

	private struct PendingBinaryOperation
	{
		let function: (Double, Double) -> Double
		let firstOperand: Double

		func perform(with seconOperand: Double) -> Double {
			return function(firstOperand, seconOperand)
		}
	}
	mutating func setOperand(_ operand: Double) {
		accumulator = operand
	}

	var result: Double? {
			return accumulator
	}
}
