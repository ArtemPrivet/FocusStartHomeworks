//
//  HeroesByID.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/2/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

// MARK: - HeroesByID
struct HeroesByID: Codable
{
	let code: Int
	let status, copyright, attributionText, attributionHTML: String
	let etag: String
	let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable
{
	let offset, limit, total, count: Int
	let results: [ResultChar]
}

// MARK: - Result
struct ResultChar: Codable
{
	let id: Int
	let name, resultDescription, modified, resourceURI: String
	let thumbnail: Thumbnail
	let comics, series, events: Comics
	let stories: Stories

	enum CodingKeys: String, CodingKey
	{
		case id, name
		case resultDescription = "description"
		case modified, thumbnail, resourceURI, comics, series, stories, events
	}
}

// MARK: - Comics
struct Comics: Codable
{
	let available: Int
	let collectionURI: String
	let items: [ComicsItem]
	let returned: Int
}

// MARK: - ComicsItem
struct ComicsItem: Codable
{
	let resourceURI: String
	let name: String
}

// MARK: - Stories
struct Stories: Codable
{
	let available: Int
	let collectionURI: String
	let items: [StoriesItem]
	let returned: Int
}

// MARK: - StoriesItem
struct StoriesItem: Codable
{
	let resourceURI: String
	let name: String
	let type: ItemType
}

enum ItemType: String, Codable
{
	case cover = "cover"
	case empty = ""
	case interiorStory = "interiorStory"
}

// MARK: - Thumbnail
struct Thumbnail: Codable
{
	let path: String
	let thumbnailExtension: Extension

	enum CodingKeys: String, CodingKey
	{
		case path
		case thumbnailExtension = "extension"
	}
}

enum Extension: String, Codable
{
	case gif
	case jpg
}
