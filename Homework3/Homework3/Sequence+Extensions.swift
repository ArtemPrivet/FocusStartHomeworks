//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap<T>(transform: (Element) -> T) -> [T] {
		var transformed = [T]()
		forEach { element in
			transformed.append(transform(element))
		}
		return transformed
	}

	func customReduce<Result>(_ ininital: Result, updateAccumulatingResult: (inout Result, Element) -> Result) -> Result {
		var result = ininital
		forEach { element in
			result = updateAccumulatingResult(&result, element)
		}
		return result
	}

	func customCompactMap<T>(transform: (Element) -> T?) -> [T] {
		var transformed = [T]()
		forEach { element in
			if let transformedElement = transform(element) {
				transformed.append(transformedElement)
			}
		}
		return transformed
	}
}
