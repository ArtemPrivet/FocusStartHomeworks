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
		var returnValue = [T]()
		for item in self {
			returnValue.append(transform(item))
		}
		return returnValue
	}

	func customReduce<T>(_ initialResult: T, _ nextPartialResult: (T, Element) -> T) -> T {
		var returnValue = initialResult
		for item in self {
			returnValue = nextPartialResult(returnValue, item)
		}
		return returnValue
	}

	func customCompactMap<T>(_ transform: (Element) -> T?) -> [T] {
		var returnValue = [T]()
		for item in self {
			guard let returnValueItem = transform(item) else { continue }
			returnValue.append(returnValueItem)
		}
		return returnValue
	}
}
