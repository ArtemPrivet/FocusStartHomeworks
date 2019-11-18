//
//  Calculator.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//
import Foundation

struct Calculator: CustomStringConvertible
{

	private var cache: (accumulator: Double?, descriptionAccumulator: String?) = (nil, nil)

	var description: String {
		guard let pendingBinaryOperation = pendingBinaryOperation else { return cache.descriptionAccumulator ?? "" }
		return pendingBinaryOperation.descriptionFunction(pendingBinaryOperation.descriptionOperand,
														  cache.descriptionAccumulator ?? "")
	}

	var result: Double? { cache.accumulator }
	var resultIsPending: Bool { pendingBinaryOperation != nil }

	private enum Operation
	{
		case nullaryOperation(() -> Double, String)
		case constant(Double)
		case unaryOperation((Double) -> Double, ((String) -> String)?)
		case binaryOperation((Double, Double) -> Double, ((String, String) -> String)?)
		case equals
	}

	private typealias Operations = [Operation]

	private var operations: [String: Operation] = [
		"π": .constant(.pi),
		"e": .constant(M_E),
		"⁺∕₋": .unaryOperation({ -$0 }, nil),           // { "±(" + $0 + ")"}
		"√": .unaryOperation(sqrt, nil),              // { "√(" + $0 + ")"}
		"cos": .unaryOperation(cos, nil),             // { "cos(" + $0 + ")"}
		"sin": .unaryOperation(sin, nil),             // { "sin(" + $0 + ")"}
		"tan": .unaryOperation(tan, nil),             // { "tan(" + $0 + ")"}
		"sin⁻¹": .unaryOperation(asin, nil),         // { "sin⁻¹(" + $0 + ")"}
		"cos⁻¹": .unaryOperation(acos, nil),         // { "cos⁻¹(" + $0 + ")"}
		"tan⁻¹": .unaryOperation(atan, nil),        // { "tan⁻¹(" + $0 + ")"}
		"ln": .unaryOperation(log, nil),             //  { "ln(" + $0 + ")"}
		"x⁻¹": .unaryOperation({ 1 / $0 }, { "(" + $0 + ")⁻¹" }),
		"х²": .unaryOperation({ $0 * $0 }, { "(" + $0 + ")²" }),
		"%": .unaryOperation({ $0 / 100 }, nil),
		"×": .binaryOperation(*, nil),                // { $0 + " × " + $1 }
		"÷": .binaryOperation(/, nil),                // { $0 + " ÷ " + $1 }
		"+": .binaryOperation(+, nil),                // { $0 + " + " + $1 }
		"−": .binaryOperation(-, { $0 + " - " + $1 }),                // { $0 + " - " + $1 }
		"xʸ": .binaryOperation(pow, { $0 + " ^ " + $1 }),
		"=": .equals,
	]

	mutating func pushOperand(_ operand: Double) {
		cache.accumulator = operand
		if let value = cache.accumulator {
			cache.descriptionAccumulator = AppSetting.formatter.string(from: NSNumber(value: value)) ?? ""
		}
	}

	mutating func performOperation(_ symbol: String) {

		if let operation = operations[symbol] {
			switch operation {

			case let .nullaryOperation(function, descriptionValue):
				cache = (function(), descriptionValue)

			case .constant(let value):
				cache = (value, symbol)

			case .unaryOperation (let function, var descriptionFunction):
				guard let accumulator = cache.accumulator else { break }
				cache.accumulator = function(accumulator)
				descriptionFunction = descriptionFunction ?? { symbol + "(" + $0 + ")" }
				cache.descriptionAccumulator = descriptionFunction?(cache.descriptionAccumulator ?? "")

			case .binaryOperation (let function, var descriptionFunction):
				performPendingBinaryOperation()
				guard let accumulator = cache.accumulator else { break }
				descriptionFunction = descriptionFunction ?? { $0 + " " + symbol + " " + $1 }
				guard let descriptionFunction = descriptionFunction else { break }
				pendingBinaryOperation = PendingBinaryOperation(function: function,
																firstOperand: accumulator,
																descriptionFunction: descriptionFunction,
																descriptionOperand: cache.descriptionAccumulator ?? "")
				cache = (nil, nil)

			case .equals:
				performPendingBinaryOperation()
			}
		}
	}

	private mutating func  performPendingBinaryOperation() {
		guard pendingBinaryOperation != nil, let accumulator = cache.accumulator else { return }
		cache.accumulator = pendingBinaryOperation?.perform(with: accumulator)
		cache.descriptionAccumulator = pendingBinaryOperation?.performDescription(with: cache.descriptionAccumulator ?? "")
		pendingBinaryOperation = nil
	}

	private var pendingBinaryOperation: PendingBinaryOperation?

	private struct PendingBinaryOperation
	{
		let function: (Double, Double) -> Double
		let firstOperand: Double
		var descriptionFunction: (String, String) -> String
		var descriptionOperand: String

		func perform(with secondOperand: Double) -> Double {
			function(firstOperand, secondOperand)
		}

		func performDescription(with secondOperand: String) -> String {
			descriptionFunction(descriptionOperand, secondOperand)
		}
	}

	mutating func clear() {
		cache = (nil, " ")
		pendingBinaryOperation = nil
	}
}
