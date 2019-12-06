//
//  Heroe.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

struct HeroesDataWrapper: Codable
{
	let code: Int?
	let status, copyright, attributionText: String?
	let attributionHTML: String?
	let data: HeroesDataContainer?
	let etag: String?
}

// MARK: - DataClass
struct HeroesDataContainer: Codable
{
	let offset, limit, total, count: Int?
	let results: [Heroe]?
}

// MARK: - Result
struct Heroe: Codable
{
	let id: Int?
	let name, resultDescription, modified: String?
	let resourceURI: String?
	let urls: [URLElement]?
	let thumbnail: Thumbnail?
	let comics: Comics?
	let stories: Stories?
	let events, series: Comics?

	enum CodingKeys: String, CodingKey
	{
		case id, name
		case resultDescription = "description"
		case modified, resourceURI, urls, thumbnail, comics, stories, events, series
	}
}

// MARK: - Comics
struct Comics: Codable
{
	let available, returned: Int?
	let collectionURI: String?
	let items: [ComicsItem]?
}

// MARK: - ComicsItem
struct ComicsItem: Codable
{
	let resourceURI, name: String?
}

// MARK: - Stories
struct Stories: Codable
{
	let available, returned: Int?
	let collectionURI: String?
	let items: [StoriesItem]?
}

// MARK: - StoriesItem
struct StoriesItem: Codable
{
	let resourceURI, name, type: String?
}

// MARK: - Thumbnail
struct Thumbnail: Codable
{
	let path, thumbnailExtension: String?

	enum CodingKeys: String, CodingKey
	{
		case path
		case thumbnailExtension = "extension"
	}
}

// MARK: - URLElement
struct URLElement: Codable
{
	let type, url: String?
}
