//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap<T>(_ transform: (Element) -> T) -> [T] {
		var transformedElements = [T]()
		for element in self {
			transformedElements.append(transform(element))
		}
		return transformedElements
	}

	func customReduce<T>(_ initialResult: T, _ nextPartialResult: (T, Element) -> T) -> T {
		var finalResult = initialResult
		for element in self {
			finalResult = nextPartialResult(finalResult, element)
		}
		return finalResult
	}

	func customCompactMap<T>(_ transform: (Element) -> T?) -> [T] {
		var transformedElements = [T]()
		for element in self {
			if let transformed = transform(element) {
				transformedElements.append(transformed)
			}
		}
		return transformedElements
	}
}
