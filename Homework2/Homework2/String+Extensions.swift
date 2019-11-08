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
		let splitedString = split(separator: " ")
		var reversedWords = ""
		for word in splitedString{
			if word == splitedString.last {
				reversedWords += word.reversed()
			}
			else {
				reversedWords += word.reversed() + " "
			}
		}
		return reversedWords
	}

	func validate() -> Bool {
		//Проверяем наличие символов в строке
		for char in self {
			if (char >= "a" && char <= "z") || (char >= "A" && char <= "Z") {
			   return false
			}
		}
		//Удаляем все лишнее
		let filteredStr = self.filter("+0123456789.".contains)
		//Если номер начинается с "+7"
		if filteredStr.count == 12 {
			let firstIndex = filteredStr.startIndex
			let secondIndex = filteredStr.index(firstIndex, offsetBy: 1)
			if filteredStr[firstIndex] == "+" && filteredStr[secondIndex] == "7" {
				if codeValidation(filteredStr: filteredStr, start: secondIndex) {
					return true
				}
			}
		}
		//Если номер начинается с  7 или 8
		if filteredStr.count == 11 {
			let firstIndex = filteredStr.startIndex
			if filteredStr[firstIndex] == "7" || filteredStr[firstIndex] == "8" {
				if codeValidation(filteredStr: filteredStr, start: firstIndex) {
					return true
				}
			}
		}
		return false
	}

	private func codeValidation(filteredStr: String, start: String.Index) -> Bool {

		let firstIndex = filteredStr.index(start, offsetBy: 1)
		let secondIndex = filteredStr.index(firstIndex, offsetBy: 3)
		let buffer = Int(filteredStr[firstIndex..<secondIndex])
		if let code = buffer {
			if code >= 900 && code <= 999 {
				return true
			}
		}
		return false
	}
}
