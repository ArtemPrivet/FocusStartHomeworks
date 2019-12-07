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
	let id: Int
	let title: String?
	let description: String?
	let thumbnail: Thumbnail

	static let empty = Comics(id: 0, title: "", description: nil,
							  thumbnail: Thumbnail(path: "", thumbnailExtension: ""))
}

extension Comics: IMarvelItemDetails
{
	var name: String? { nil }
	var fullName: String? { nil }
}
