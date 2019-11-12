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
		var transformed = [T]()
		forEach { transformed.append(transform($0)) }
		return transformed
	}

	func customReduce<Result>(
		_ ininital: Result,
		_ updateAccumulatingResult: (Result, Element) -> Result
	) -> Result {
		var result = ininital
		forEach { element in
			result = updateAccumulatingResult(result, element)
		}
		return result
	}

	func customCompactMap<T>(_ transform: (Element) -> T?) -> [T] {
		var transformed = [T]()
		forEach { element in
			if let transformedElement = transform(element) {
				transformed.append(transformedElement)
			}
		}
		return transformed
	}
}
