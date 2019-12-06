//
//  ComicsResponse.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

struct ComicsResponse: Decodable
{
	let data: ComicsData
}

struct ComicsData: Decodable
{
	let results: [Comics]
	let total: Int
	let limit: Int
	let count: Int
}

struct Comics: Decodable, IEntity
{
	let title: String
	let thumbnail: Thumbnail

	let id: Int
	var description: String?
	var showingName: String? {
		return title
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
