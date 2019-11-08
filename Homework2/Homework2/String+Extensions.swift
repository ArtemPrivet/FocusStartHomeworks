//
//  Calculator.swift
//  Homework2
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

// ЗАДАНИЕ:
// Сделать расширение класса String c 2 методами:
// 1. Метод возвращает строку с развернутыми словам.
// Порядок слов не меняется, меняется порядок букв в словах.
// Пример: "hello world" -> "olleh dlrow"
// Сигнатура метода: .reversedWords() -> String

// 2. Метод проверяет номер мобильного телефона на правильность.
// Коды русских номеров телефонов - 900...999, номер может начинаться
// с '+7', '7' и '8'. Номер можно вводить и со скобками и с черточками
// и пробелами.
// Сигнатура метода: .validate() -> Bool

extension String
{
	func reversedWords() -> String {
		let result = self
		.components(separatedBy: " ")
		.map{ String($0.reversed()) }
		.joined(separator: " ")
		return result
	}

	func validate() -> Bool {
		var isValidated = true
		let allowedCharacter: Set<Character> = ["+", "(", ")", " ", "-", "+"]
		var characterArray = [Character]()
		self.forEach { character in
			guard character.isNumber || allowedCharacter.contains(character) else { isValidated = false; return }
			characterArray.append(character)
		}
		guard isValidated == true else { return false }
		if characterArray[0] == "7" || characterArray[0] == "8" ||
		(characterArray[0] == "+" && characterArray[1] == "7") {
			let intArray = characterArray.compactMap{ Int(String($0)) }
			print("int array = \(intArray)")
			guard intArray[1] == 9 && intArray.count == 11 else { return false }
			return true
			}
		return false
		}
}
