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
		self.forEach { element in
			result.append(transform(element))
		}
		return result
	}

	func customReduce<Result>(_ initialResult: Result,
							  _ nextPartialResult: (Result, Element) -> Result) -> Result {
		var result = initialResult
		self.forEach { element in
			result = nextPartialResult(result, element)
		}
		return result
	}

	func customCompactMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
		var result: [ElementOfResult] = []
		self.forEach { element in
			if let transformResult = transform(element) {
				result.append(transformResult)
			}
		}
		return result
	}
}
