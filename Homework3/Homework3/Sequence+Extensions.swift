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
		var result: [T] = []
		for element in self {
			result.append(transform(element))
		}
		return result
	}

	func customReduce<T>(_ initialResult: T, _ nextPartialResult: (T, Element) -> T) -> T {
		var result = initialResult
		for element in self {
			result = nextPartialResult(result, element)
		}
		return result
	}

	func customCompactMap<T>(_ transform: (Element) -> (T?)) -> [T] {
		var result: [T] = []
		self.forEach {
			guard let transformed = transform($0) else { return }
			result.append(transformed)
		}
		return result
	}
}
