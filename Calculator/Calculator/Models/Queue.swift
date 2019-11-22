//
//  Queue.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

protocol IQueue
{
	associatedtype Element
	mutating func push(_ element: Element)
	mutating func pop() -> Element?
}

struct Queue<Element>: IQueue
{
	private var queue = [Element]()

	mutating func push(_ element: Element) { queue.append(element) }

	mutating func pop() -> Element? {
		guard queue.isEmpty == false else { return nil }
		return queue.removeFirst()
	}
}

extension Queue: CustomStringConvertible
{
	var description: String { "\(queue)" }
}
