//
//  CharacterResponse.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

struct CharacterResponse: Decodable
{
	let data: CharacterData
}

struct CharacterData: Decodable
{
	let results: [Character]
	let total: Int
	let limit: Int
	let count: Int
}

struct Character: Decodable, IEntity
{
	let name: String
	let thumbnail: Thumbnail

	let id: Int
	let description: String?
	var showingName: String? {
		return name
	}
	var squareImageURL: URL? {
		return ImageURLGenerator.smallSquare.getURL(thumbnail.path, ext: thumbnail.extensionTitle)
	}
	var portraitImageURL: URL? {
		return ImageURLGenerator.smallPortrait.getURL(thumbnail.path, ext: thumbnail.extensionTitle)
	}
	var bigImageURL: URL? {
		return ImageURLGenerator.bigSquare.getURL(thumbnail.path, ext: thumbnail.extensionTitle)
	}
}
