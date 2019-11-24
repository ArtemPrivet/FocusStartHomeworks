//
//  CalculatorEngine.OperationStack+Equatable.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 25.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

extension CalculatorEngine.OperationStack: Equatable
{
	static func == (lhs: CalculatorEngine.OperationStack, rhs: CalculatorEngine.OperationStack) -> Bool {
		switch (lhs, rhs) {
		case (.operand(let lhsOperand), .operand(let rhsOperand)):
			return lhsOperand == rhsOperand
		case (.operator(let lhsOperator), .operator(let rhsOperator)):
			return lhsOperator == rhsOperator
		default:
			return false
		}
	}
}
