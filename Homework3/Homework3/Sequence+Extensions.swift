//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap<T>(_ transform: (Element) -> (T)) -> [T] {
		var result = [T]()
		forEach { result.append(transform($0)) }
		return result
	}

	func customReduce<Result>( _ initialResult: Result, _ nextPatrialResult: (Result, Element) -> Result) -> Result {
		var result = initialResult
		forEach { result = nextPatrialResult(result, $0) }
		return result
	}

	func customCompactMap<ElementOfResult>(_ trasform: (Element) -> (ElementOfResult?)) -> [ElementOfResult] {
		var result = [ElementOfResult]()
		forEach {
			if let value = trasform($0) {
				result.append(value)
			}
		}
		return result
	}
}
