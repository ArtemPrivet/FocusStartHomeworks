//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap<T>(using closure: (Element) -> T) -> [T] {
		var result: [T] = []
		for element in self {
			result.append(closure(element))
		}
		return result
	}

	func customReduce<T>(_ accumulator: T, using closure: (T, Element) -> T) -> T {
		var result = accumulator
		for element in self {
			result = closure( result, element)
		}
		return result
	}

	func customCompactMap<T>(using closure: (Element) -> T?) -> [T] {
		var result: [T] = []
		for element in self {
			if let newElement = closure(element) {
				result.append(newElement)
			}
		}
		return result
	}
}
