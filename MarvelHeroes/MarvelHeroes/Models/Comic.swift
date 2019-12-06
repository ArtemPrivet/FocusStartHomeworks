//
//  Comic.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 04/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

struct ComicsDataWrapper: Codable
{
	let code: Int?
	let status: String?
	let copyright: String?
	let attributionText: String?
	let attributionHTML: String?
	let data: ComicsDataContainer?
	let etag: String?
}

struct ComicsDataContainer: Codable
{
	let offset: Int?
	let limit: Int?
	let total: Int?
	let count: Int?
	let results: [Comic]?
}

struct Comic: Codable
{
	let id: Int?
	let digitalID: Int?
	let title: String?
	let issueNumber: Double?
	let variantDescription: String?
	let comicDescription: String?
	let modified: Date?
	let isbn: String?
	let upc: String?
	let diamondCode: String?
	let ean: String?
	let issn: String?
	let format: String?
	let pageCount: Int?
	let textObjects: [TextObject]?
	let resourceURI: String?
	let urls: [ComicUrl]?
	let series: SeriesSummary?
	let variants: [ComicSummary]?
	let collections: [ComicSummary]?
	let collectedIssues: [ComicSummary]?
	let dates: [ComicDate]?
	let prices: [ComicPrice]?
	let thumbnail: ComicThumbnail?
	let images: [ComicThumbnail]?
	let creators: CreatorList?
	let characters: CharacterList?
	let stories: StoryList
	let events: EventList

	enum CodingKeys: String, CodingKey
	{
		case id
		case digitalID = "digitalId"
		case title, issueNumber, variantDescription
		case comicDescription = "description"
		case modified, isbn, upc, diamondCode, ean, issn, format, pageCount
		case textObjects, resourceURI, urls, series, variants, collections
		case collectedIssues, dates, prices, thumbnail, images, creators, characters, stories, events
	}
}

struct TextObject: Codable
{
	let type: String?
	let language: String?
	let text: String?
}

struct ComicUrl: Codable
{
	let type: String?
	let url: String?
}

struct SeriesSummary: Codable
{
	let resourceURI: String?
	let name: String?
}

struct ComicSummary: Codable
{
	let resourceURI: String?
	let name: String?
}

struct ComicDate: Codable
{
	let type: String?
	let date: Date?
}

struct ComicPrice: Codable
{
	let type: String?
	let price: Float?
}

struct ComicThumbnail: Codable
{
	let path: String?
	let thumbnailExtension: String?

	enum CodingKeys: String, CodingKey
	{
		case path
		case thumbnailExtension = "extension"
	}
}

struct CreatorList: Codable
{
	let available: Int?
	let returned: Int?
	let collectionURI: String?
	let items: [CreatorSummary]?
}

struct CreatorSummary: Codable
{
	let resourceURI: String?
	let name: String?
	let role: String?
}

struct CharacterList: Codable
{
	let available: Int?
	let returned: Int?
	let collectionURI: String?
	let items: [CharacterSummary]?
}

struct CharacterSummary: Codable
{
	let resourceURI: String?
	let name: String?
	let role: String?
}

struct StoryList: Codable
{
	let available: Int?
	let returned: Int?
	let collectionURI: String?
	let items: [StorySummary]?
}

struct StorySummary: Codable
{
	let resourceURI: String?
	let name: String?
	let type: String?
}

struct EventList: Codable
{
	let available: Int?
	let returned: Int?
	let collectionURI: String?
	let items: [EventSummary]?
}

struct EventSummary: Codable
{
	let resourceURI: String?
	let name: String?
}
