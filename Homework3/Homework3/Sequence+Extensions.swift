//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{

	func customMap<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
		return try compactMap(transform)
	}

	func customReduce<Result>(_ initialResult: Result,
							  _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
		try customReduce(into: initialResult) {
			$0 = try nextPartialResult($0, $1)
		}
	}

	func customReduce<Result>(into result: Result,
							  _ updateAccumulatingResult: (inout Result, Element) throws -> Swift.Void) rethrows -> Result {
		var result = result
		try forEach { try updateAccumulatingResult(&result, $0) }
		return result
	}

	func customCompactMap<ElementOfResult>(
		_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
		try customReduce(into: []) {
			if let transformElement = try transform($1) {
				$0.append(transformElement)
			}
		}
	}
}
