//
//  Animal.swift
//  Test
//
//  Created by Artem Orlov on 26/10/2019.
//

struct Animal {
	let name :String
	let legCount: Int
	func move() {
		print("\(name) with \(legCount) legs is moving")
	}

	init?(name: String, legCount: Int) {
		guard legCount >= 0 else {
			return nil
		}
		self.name = name
		self.legCount = legCount
	}


	
}
