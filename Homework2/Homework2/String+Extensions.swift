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
		var newString: String = ""
		let separator = " "

		if self.contains(separator) {
			let wordsArray = self.components(separatedBy: separator)
			for (wordIndex, newWord) in wordsArray.enumerated() {
				newString += newWord.reversed()
				if wordIndex < (wordsArray.endIndex - 1) {
					newString += separator
				}
			}
		}
		else {
			newString = String(self.reversed())
		}

		return newString
	}

	func validate() -> Bool {
		var number = self
		var result = false

		number = number.filter {
			$0 != " " &&
			$0 != "(" &&
			$0 != ")" &&
			$0 != "-"
		}

		if number.hasPrefix("7") || number.hasPrefix("8") {
			number.removeFirst()
		}
		else if number.hasPrefix("+7") {
			number = String(number.dropFirst(2))
		}
		else {
			return false
		}

		let code = number.prefix(3)

		if let codeInt = Int(code) {
			if codeInt >= 900 && codeInt <= 999 && number.count == 10 && (Int(number) != nil) {
				result = true
			}
		}
		return result
	}
}
