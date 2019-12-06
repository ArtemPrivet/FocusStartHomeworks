//
//  Text.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

struct Text: Codable
{
	let type: `Type`
	let language: Language
	let text: String

	enum Language: String, Codable
	{
		case enUs = "en-us"
	}

	enum `Type`: String, Codable
	{
		case issueSolicitText = "issue_solicit_text"
	}
}
