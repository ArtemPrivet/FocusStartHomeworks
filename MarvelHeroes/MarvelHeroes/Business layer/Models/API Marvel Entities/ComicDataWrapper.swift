//
//  ComicDataWrapper.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation

// MARK: - ComicDataWrapper
struct ComicDataWrapper: IItemDataWrapper
{
	let code: Int
	let status, copyright, attributionText, attributionHTML: String
	let etag: String
	let data: ComicDataContainer
}

// MARK: - ComicDataContainer
struct ComicDataContainer: Codable
{
	let offset, limit, total, count: Int
	let results: [Comic]
}

// MARK: - Comic
struct Comic: Codable, IItemViewModel
{
	let id, digitalId: Int
	let title: String
//    let issueNumber: Int
//    let variantDescription: String
	let description: String?
//    let modified: Date
//    let isbn, upc, diamondCode, ean: String
//    let issn: String
//    let format: Format
//    let pageCount: Int
//    let textObjects: [TextObject]
//    let resourceURI: String
////    let urls: [URLElement]
//    let series: SeriesSummary
//    let variants, collections: [ComicSummary]
//    let collectedIssues: [ComicSummary]
////    let dates: [ComicDate]
//    let prices: [ComicPrice]
	let thumbnail: Thumbnail
//    let images: [Thumbnail]
//    let creators: CreatorList
//    let characters: CharacterList
////    let stories: StoryList
//    let events: EventList

	// MARK: Calculated properties
	var itemType: ItemType { .comic }
}
