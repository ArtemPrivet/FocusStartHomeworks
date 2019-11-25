//
//  Stack.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 19.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

protocol IStack
{
	associatedtype Element
	mutating func removeAll()
	mutating func push(_ element: Element)
	mutating func pop() -> Element?

	var top: Element? { get }
}

struct Stack<Element>: IStack
{

	var isEmpty: Bool { array.isEmpty }
	var count: Int { array.count }
	var top: Element? { array.last }

	private var array: [Element] = []

	mutating func removeAll() { array.removeAll() }

	mutating func push(_ element: Element) { array.append(element) }

	@discardableResult mutating func pop() -> Element? { array.popLast() }
}

extension Stack: CustomStringConvertible
{
	var description: String { "\(array)" }
}
