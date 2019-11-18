//
//  Calculator.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 18.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

enum OperationType
{
	case unary, binary
}

enum Operation: String
{
	case multiply = "×"
	case divide = "÷"
	case minus = "−"
	case sum = "+"
	case percent = "%"
	case allClear = "AC"
	case clear = "C"
	case negate = "⁺∕₋"
	case comma = ","
}

struct Calculator
{
	var firstOperand = 0.0
	var secondOperand: Double?
	var currentOperationType: OperationType = .unary
	var currentOperation: Operation?

	mutating func calculate(from string: String?) -> String {
		guard let symbol = string else { return "error" }
		if let number = Double(symbol) {
			// it's a some number
			if secondOperand == nil {
				firstOperand = number
				return "\(formatted(firstOperand))"
			}
			else {
				secondOperand = number
				return "\(formatted(secondOperand ?? 0))"
			}
		}
		else {
			//it's an operator

			switch currentOperationType {
			case .unary:
				firstOperand = makeNegated(firstOperand)
				return "\(formatted(firstOperand))"
			case .binary: break
				//binary operations
			}
			return ""
		}
	}

// MARK: DEFINE OPERATIONS
	private func defineOperationType(from string: String) -> OperationType {
		switch string {
		case Operation.clear.rawValue,
			 Operation.percent.rawValue,
			 Operation.allClear.rawValue,
			 Operation.clear.rawValue,
			 Operation.negate.rawValue,
			 Operation.comma.rawValue
			: return .unary
		case Operation.multiply.rawValue,
			 Operation.divide.rawValue,
			 Operation.minus.rawValue,
			 Operation.sum.rawValue
			: return .binary
		default:
			fatalError("Unknown Operation Type")
		}
	}

// MARK: FORMAT OUTPUT STRING
	private func formatted(_ number: Double) -> String {
		let string = (number == 0.0) ? "0" : String(number)
		return string.replacingOccurrences(of: ".", with: ",")
	}

// MARK: UNARY OPERATIONS METHODS
	private func percent(_ operand: Double) -> Double {
		return operand / 100
	}

	private func makeNegated(_ operand: Double) -> Double {
		var converted = operand
		converted.negate()
		return converted
	}

	private mutating func clear() {
		if firstOperand != 0 {
			firstOperand = 0
		}
		if secondOperand == nil {
			secondOperand = 0
		}
		else {
//
		}
	}
// MARK: BINARY OPERATIONS METHODS

}
