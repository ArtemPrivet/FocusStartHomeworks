//
//  Author.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 05/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

struct AuthorsDataWrapper: Codable
{
	let code: Int?
	let status: String?
	let copyright: String?
	let attributionText: String?
	let attributionHTML: String?
	let data: AuthorsDataContainer?
	let etag: String?
}

struct AuthorsDataContainer: Codable
{
	let offset: Int?
	let limit: Int?
	let total: Int?
	let count: Int?
	let results: [Author]?
}

struct Author: Codable
{
	let id: Int?
	let firstName: String?
	let secondName: String?
	let lastName: String?
	let suffix: String?
	let fullName: String?
	let modified: Date?
	let resourceURI: String?
	let urls: [URLElement]?
	let thumbnail: Thumbnail?
	let series: AuthorSeries?
	let stories: StoryList?
	let comics: AuthorSeries?
	let events: EventList?
}

struct AuthorSeries: Codable
{
	let available, returned: Int?
	let collectionURI: String?
	let items: [SeriesSummary]?
}
