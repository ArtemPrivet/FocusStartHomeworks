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
		var initialResult = initialResult
		for element in self {
			initialResult = nextPartialResult(initialResult, element)
		}
		return initialResult
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
