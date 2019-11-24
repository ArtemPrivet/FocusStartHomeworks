//
//  CalculatorEngine.OperationStack+Initialization.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 25.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

extension CalculatorEngine.OperationStack
{

	typealias FloatLiteralType = Double

	init(operand: Double) {
		self = .operand(operand)
	}

	init(`operator`: CalculatorEngine.Operator) {
		self = .operator(`operator`)
	}

	init?(string: String) {
		if let value = Double(string) {
			self.init(operand: value)
		}
		else if let `operator` = CalculatorEngine.Operator(rawValue: string) {
			self.init(operator: `operator`)
		}
		else {
			return nil
		}
	}

	init(floatLiteral value: FloatLiteralType) {
		self.init(operand: value)
	}
}
