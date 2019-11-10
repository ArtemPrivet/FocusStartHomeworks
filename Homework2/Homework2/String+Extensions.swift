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
		let arrayOfWords = self.components(separatedBy: " ")
		var result = ""
		for word in arrayOfWords {
			if result.isEmpty == false {
				result += " "
			}
			result += word.reversed()
		}
		return result
	}

	func validate() -> Bool {
		var phoneNumber = ""
		var digitNumber = ""
		for char in self {
			switch char {
			case "+": phoneNumber += String(char)
			case "a"..."z": return false
			case "0"..."9": digitNumber += String(char)
			default: continue
			}
		}
		guard digitNumber.first == "7" || digitNumber.first == "8" else { return false }
		phoneNumber += digitNumber

		if phoneNumber.first == "+" {
			guard phoneNumber.count == 12 else { return false }
			for (index, char) in phoneNumber.enumerated() where index == 2 {
					guard char == "9" else { return char == "9" }
			}
		}
		else {
			guard phoneNumber.count == 11 else { return false }
				for (index, char) in phoneNumber.enumerated() where index == 1 {
					guard char == "9" else { return char == "9" }
				}
			}
		return true
	}
}
