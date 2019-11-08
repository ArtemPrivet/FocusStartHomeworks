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
		let result = String(self.components(separatedBy: " ").map{ $0.reversed() }.joined(separator: " "))
		return result
	}

	func validate() -> Bool {
		var isValidate = true
		var array = [String]()
		self.forEach { character in
		if character != "+" && character != "(" && character != ")" && character != " " && character != "-"
		&& Int(String(character)) == nil {
				isValidate = false
			}
		array.append(String(character))
		}
		if (array[0] == "8" || array[0] == "7" || (array[0] == "+" && array[1] == "7")) && isValidate == true {
			let intArray = array.compactMap{ str in Int(str) }
			if intArray[1] == 9 && intArray.count == 11 {
				return isValidate
			}
			else {
				isValidate = false
				return isValidate
			}
		}
		else {
			isValidate = false
		}
		return isValidate
	}
}
