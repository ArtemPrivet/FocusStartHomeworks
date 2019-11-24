//
//  Array+InfixToPostfixConverter.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 24.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

// MARK: - [OperationStack]
extension Array where Element == CalculatorEngine.OperationStack
{
	func convertToPostfix() throws -> Queue<Element> {
		try InfixToPostfixConverter.convertInfixToPostfixNotation(input: self)
	}
}

// MARK: - Extension ArraySlice<OperationStack>
extension ArraySlice where Element == CalculatorEngine.OperationStack
{
	func convertToPostfix() throws -> Queue<Element> {
		try InfixToPostfixConverter.convertInfixToPostfixNotation(input: Array(self))
	}
}
