//
//  Stack.swift
//  Calculator
//
//  Created by Иван Медведев on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct Stack<Element>
{
	private var array: [Element] = []

	var isEmpty: Bool {
		return array.isEmpty
	}

	var top: Element? {
		return array.last
	}

	mutating func push(newElement: Element) {
		self.array.append(newElement)
	}

	mutating func pop() -> Element? {
		return self.array.popLast()
	}
}
