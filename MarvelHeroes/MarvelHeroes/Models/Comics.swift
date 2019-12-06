//
//  Comics.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation

struct ComicsServerResponse: Decodable
{
	let data: ComicsData
}

struct ComicsData: Decodable
{
	let results: [Comics]
}

// MARK: - Comics
struct Comics: Decodable
{
	let title: String?
	let description: String?
	let resourceURI: String
	let thumbnail: Thumbnail
	let creators: SubItemsCollection?

	static let empty = Comics(title: "", description: nil,
							  resourceURI: "",
							  thumbnail: Thumbnail(path: "", thumbnailExtension: ""),
							  creators: SubItemsCollection(items: []))
}

extension Comics: IMarvelItemDetails
{
	var subItemsCollection: SubItemsCollection? {
		return creators
	}

	var name: String? { nil }
	var fullName: String? { nil }
}
