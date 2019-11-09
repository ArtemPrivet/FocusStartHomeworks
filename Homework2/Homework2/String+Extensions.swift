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
		let splitted = split(separator: " ")
		var reversedWords = ""
		for (index, word) in splitted.enumerated() {
			if index == splitted.count - 1 {
				reversedWords += word.reversed()
			}
			else {
				reversedWords += word.reversed() + " "
			}
		}
		return reversedWords
	}

	func validate() -> Bool {
		func validate() -> Bool {
			//Проверяем наличие символов в строке
			for char in self {
				if (char >= "a" && char <= "z") || (char >= "A" && char <= "Z") {
				   return false
				}
			}
			//Удаляем все лишнее
			let filtered = self.filter("+0123456789.".contains)
			//Если номер начинается с "+7"
			if filtered.count == 12 {
				let firstIndex = filtered.startIndex
				let secondIndex = filtered.index(firstIndex, offsetBy: 1)
				if filtered.prefix(2) == "+7" {
					return findCodeAndCheck(filtered: filtered, start: secondIndex)
				}
			}
			//Если номер начинается с  7 или 8
			if filtered.count == 11 {
				let firstIndex = filtered.startIndex
				if filtered[firstIndex] == "7" || filtered[firstIndex] == "8" {
					return findCodeAndCheck(filtered: filtered, start: firstIndex)
				}
			}
			return false
		}

		private func findCodeAndCheck(filtered: String, start: String.Index) -> Bool {
			let firstIndex = filtered.index(start, offsetBy: 1)
			let secondIndex = filtered.index(firstIndex, offsetBy: 3)
			let buffer = Int(filtered[firstIndex..<secondIndex])
			if let code = buffer {
				if code >= 900 && code <= 999 {
					return true
				}
			}
			return false
		}
	}
}
