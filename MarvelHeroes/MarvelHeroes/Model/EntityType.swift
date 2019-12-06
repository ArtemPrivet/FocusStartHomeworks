//
//  EntityType.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
import Foundation

enum EntityType
{
	case character
	case comics
	case author
	//Тайтлы для navigationcontroller
	func getNavigationTitle() -> String {
		switch self {
		case .character:
			return "🦸‍♂️Heroes"
		case .comics:
			return "Comics"
		case .author:
			return "Authors"
		}
	}
	//тайтлы для таббара
	func getTabTitle() -> String {
		switch self {
		case .character:
			return "Heroes"
		case .comics:
			return "Comics"
		case .author:
			return "Authors"
		}
	}
	//Директория для запроса данных в детализации
	func directoryOfAccessories(id: Int) -> String {
		switch self {
		case .character:
			return "characters/\(id)/comics"
		case .comics:
			return "comics/\(id)/creators"
		case .author:
			return "creators/\(id)/comics"
		}
	}
	//Директория для запросов
	func getEntityDirectory() -> String {
		switch self {
		case .character:
			return "characters"
		case .comics:
			return "comics"
		case .author:
			return "creators"
		}
	}
	//Название параметров передаваемых для фильтрации
	func getEntityQueryParameter() -> String {
		switch self {
		case .character:
			return "nameStartsWith"
		case .comics:
			return "titleStartsWith"
		case .author:
			return "nameStartsWith"
		}
	}
}
