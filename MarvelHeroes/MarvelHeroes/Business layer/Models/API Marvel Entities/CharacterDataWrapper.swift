//
//  CharacterDataWrapper.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation

// MARK: - CharacterDataWrapper
struct CharacterDataWrapper: IItemDataWrapper
{
	let code: Int
	let status, copyright, attributionText, attributionHTML: String
	let etag: String
	var data: CharacterDataContainer
}

// MARK: - CharacterDataContainer
struct CharacterDataContainer: Codable
{
	let offset, limit, total, count: Int
	let results: [Character]
}

// MARK: - Character
struct Character: Codable, IItemViewModel
{
	let id: Int
	let title: String
	let description: String?
	let modified: Date
	let thumbnail: Thumbnail
	let resourceURI: String
	let comics: ComicList
	let series: SeriesList
	let stories: StoryList
	let events: EventList
	let urls: [URLElement]

	// MARK: Calculated properties
	var itemType: ItemType { .charactor }

	enum CodingKeys: String, CodingKey
	{
		case id
		case title = "name"
		case description, modified, thumbnail, resourceURI, comics, series, stories, events, urls
	}
}
