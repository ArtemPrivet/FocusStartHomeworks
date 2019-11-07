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
		let someArray = self.components(separatedBy: " ")
		var string = ""
		for index in 0...someArray.count - 1 {
			if string.isEmpty == false {
				string += " "
			}
			string += someArray[index].reversed()
		}
		return String(string)
	}

	func validate() -> Bool {
		var string = ""
		var string2 = ""
		for index in self {
			switch index {
			case "+": string += String(index)
			case "a"..."z": return false
			case "0"..."9": string2 += String(index)
			default: continue
			}
		}
		guard string2.first == "7" || string2.first == "8" else { return false }
		string += string2

		if string.first == "+" {
			guard string.count == 12 else { return false }
			for (key, value) in string.enumerated() where key == 2 {
					guard value == "9" else { return false }
			}
		}
		else {
			guard string.count == 11 else { return false }
				for (key, value) in string.enumerated() where key == 1 {
					guard value == "9" else { return false }
				}
			}
		return true
	}
}
