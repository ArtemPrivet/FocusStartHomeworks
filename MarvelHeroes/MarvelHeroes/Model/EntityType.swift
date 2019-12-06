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

	func getNameTabImage() -> String {
		switch self {
		case .character:
			return "shield"
		case .comics:
			return "comic"
		case .author:
			return "writer"
		}
	}
}
