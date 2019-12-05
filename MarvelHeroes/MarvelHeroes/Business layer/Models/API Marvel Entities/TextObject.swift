//
//  TextObject.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

struct TextObject: Codable
{
	let type: TextObjectType
	let language: Language
	let text: String

	enum Language: String, Codable
	{
		case enUs = "en-us"
	}

	enum TextObjectType: String, Codable
	{
		case issueSolicitText = "issue_solicit_text"
	}
}
