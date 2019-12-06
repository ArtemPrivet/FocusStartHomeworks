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
	let description: String?
	let modified: Date
	let thumbnail: Thumbnail

	// MARK: Calculated properties
	var itemType: ItemType { .comic }
}
