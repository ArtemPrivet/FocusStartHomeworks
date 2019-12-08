//
//  ComicsByID.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

// MARK: - ComicsByID
struct ComicsByID: Codable
{
	let data: DataClassic
}

// MARK: - DataClass
struct DataClassic: Codable
{
	let results: [ResultBook]
}

// MARK: - Result
struct ResultBook: Codable
{
	let id: Int
	let title: String
	let resultDescription: String?
	let thumbnail: Thumbnaill
}

// MARK: - Thumbnail
struct Thumbnaill: Codable
{
	let path: String
	let thumbnailExtension: ExtensionThumb

	enum CodingKeys: String, CodingKey
	{
		case path
		case thumbnailExtension = "extension"
	}
}

enum ExtensionThumb: String, Codable
{
	case jpg
}
