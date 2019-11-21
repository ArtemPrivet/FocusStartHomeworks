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
	private enum OperationPriority
	{
		case high
		case low
	}

	private enum Operation
	{
		case unary((Double) -> Double, ((String) -> String)?)
		case binary((Double, Double) -> Double, ((String, String) -> String)?, OperationPriority)
		case equals
	}

	private struct WaitingBinaryOperation
	{
		let function: (Double, Double) -> Double
		let firstOperand: Double

		let descriptionFunction: (String, String) -> String
		let descriptionOperand: String

		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}

		func performDescription(with secondOperand: String) -> String {
			return descriptionFunction(descriptionOperand, secondOperand)
		}
	}

	private var waitingBinaryOperation: WaitingBinaryOperation?

	private let operations: [String: Operation] = [
		"⁺∕₋": .unary ({ -$0 }, { "⁺∕₋(" + $0 + ")" }),
		"%": .unary ({ $0 / 100 }, { "%" + $0 }),
		"÷": .binary ({ $0 / $1 }, { $0 + "÷" + $1 }, .high),
		"×": .binary ({ $0 * $1 }, { $0 + "×" + $1 }, .high),
		"−": .binary ({ $0 - $1 }, { $0 + "−" + $1 }, .low),
		"+": .binary ({ $0 + $1 }, { $0 + "+" + $1 }, .low),
		"=": .equals,
	]

	private var accumulatedValue: Double?
	private var accumulatedDescription: String?

	var result: Double? {
		return accumulatedValue
	}

	var description: String? {
		if waitingBinaryOperation == nil {
			return accumulatedDescription
		}
		else {
			guard let operation = waitingBinaryOperation else { return nil }
			return operation.descriptionFunction(operation.descriptionOperand, accumulatedDescription ?? "")
		}
	}

	 var resultIsWaiting: Bool {
		waitingBinaryOperation != nil
	}

	mutating func performCalculation(_ symbol: String) {
		guard let operation = operations[symbol] else { return }
		switch operation {
		case .unary(let perform, let descriptionFunction):
			if let notEmptyValue = accumulatedValue {
				accumulatedValue = perform(notEmptyValue)
				if var descriptionFunction = descriptionFunction {
					descriptionFunction = { symbol + "(" + $0 + ")" }
					accumulatedDescription = descriptionFunction(accumulatedDescription ?? "")
				}
			}
		case .binary(let perform, let descriptionFunction, let priority):
			if let value = accumulatedValue,
				let description = accumulatedDescription,
				let descriptionFunction = descriptionFunction {
				waitingBinaryOperation = WaitingBinaryOperation(
					function: perform,
					firstOperand: value,
					descriptionFunction: descriptionFunction,
					descriptionOperand: description
				)
				accumulatedValue = nil
				accumulatedDescription = nil
			}
		case .equals:
			performWaitingBinaryOperation()
		}
	}

	private mutating func performWaitingBinaryOperation() {
		if let operation = waitingBinaryOperation,
		let value = accumulatedValue,
		let description = accumulatedDescription {
		accumulatedValue = operation.perform(with: value)
		accumulatedDescription = waitingBinaryOperation?.performDescription(with: description)
		waitingBinaryOperation = nil
		}
	}

	mutating func setOperand(_ operand: Double) {
		accumulatedValue = operand
		if let value = accumulatedValue {
			accumulatedDescription = formatter.string(from: NSNumber(value: value)) ?? ""
		}
	}

	mutating func allClear() {
		accumulatedValue = nil
		waitingBinaryOperation = nil
		accumulatedDescription = ""
	}
}

extension Calculator
{
	var formatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.usesGroupingSeparator = true
		formatter.notANumberSymbol = "NaN"
		formatter.groupingSeparator = " "
		formatter.locale = Locale.current
		return formatter
	}
}
