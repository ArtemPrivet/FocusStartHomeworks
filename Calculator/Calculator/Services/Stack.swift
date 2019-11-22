//
//  Stack.swift
//  Calculator
//
//  Created by Максим Шалашников on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct Stack<T>
{
	private var array: [T] = []
	var count: Int {
		return array.count
	}
	var isEmpty: Bool {
		return array.isEmpty
	}

	mutating func push(_ element: T) {
		array.append(element)
	}
	mutating func pop() -> T? {
		return array.popLast()
	}
	func peek() -> T? {
		return array.first
	}
	func last() -> T? {
		return array.last
	}
	mutating func clear() {
		array = []
	}
	func toArray() -> [T] {
		return array
	}
}
