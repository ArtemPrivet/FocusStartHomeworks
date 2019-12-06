//
//  AuthorResponse.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

struct AuthorResponse: Decodable
{
	let data: AuthorData
}

struct AuthorData: Decodable
{
	let results: [Author]
	let total: Int
	let limit: Int
	let count: Int
}

struct Author: Decodable, IEntity
{
	let firstName: String
	let lastName: String
	let middleName: String
	let fullName: String
	let thumbnail: Thumbnail

	var id: Int
	var showingName: String? {
		return fullName
	}
	var description: String? {
		return ""
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
