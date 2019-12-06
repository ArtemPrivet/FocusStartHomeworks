//
//  Author.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation

// MARK: - AuthorsServerResponse
struct AuthorsServerResponse: Decodable
{
	let data: AuthorsData
}

// MARK: - ComicsData
struct AuthorsData: Decodable
{
	let results: [Author]
}

// MARK: - Result
struct Author: Decodable
{
	let fullName: String?
	let thumbnail: Thumbnail
	let resourceURI: String
	let comics: SubItemsCollection?

	static let empty = Author(fullName: "",
							  thumbnail: Thumbnail(path: "", thumbnailExtension: ""),
							  resourceURI: "",
							  comics: SubItemsCollection(items: []))
}

extension Author: IMarvelItemDetails
{
	var subItemsCollection: SubItemsCollection? {
		return comics
	}

	var name: String? { nil }
	var description: String? { nil }
	var title: String? { nil }
}
