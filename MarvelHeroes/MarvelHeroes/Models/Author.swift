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
	let id: Int
	let fullName: String?
	let thumbnail: Thumbnail

	static let empty = Author(
		id: 0,
		fullName: "",
		thumbnail: Thumbnail(path: "", thumbnailExtension: ""))
}

extension Author: IMarvelItemDetails
{
	var name: String? { nil }
	var description: String? { nil }
	var title: String? { nil }
}
