//
//  Calculator.swift
//  Homework3
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

extension Sequence
{
	func customMap<T>(_ prepare: (Element) -> T) -> [T] {
		var result = [T]()
		self.forEach {
			result.append(prepare($0))
		}
		return result
	}

	func customReduce<T>(_ firstElement: T, prepare: (T, Element) -> T) -> T {
		var result = firstElement
		self.forEach {
			result = prepare(result, $0)
		}
		return result
	}

	func customCompactMap<T>(_ prepare: (Element) -> T?) -> [T] {
		var result = [T]()
		self.forEach {
			guard let newElement = prepare($0) else { return }
			result.append(newElement)
		}
		return result
	}
}
