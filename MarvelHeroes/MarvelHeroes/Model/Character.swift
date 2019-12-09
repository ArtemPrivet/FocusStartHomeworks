//
//  Character.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 02.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation

struct DataWrapper: Decodable
{
	let code: Int
	let status: String
	let copyright: String
	let attributionText: String
	let attributionHTML: String
	let etag: String
	let data: DataContainer
}

struct DataContainer: Decodable
{
	let offset: Int
	let limit: Int
	let total: Int
	let count: Int
	let results: [Character]
	let etag: String?
}

struct Character: Decodable
{
	let id: Int
	let name: String
	let description: String
	let thumbnail: Image
}

struct Image: Decodable
{
	let path: String?
	let imageExtension: String?

	enum CodingKeys: String, CodingKey
	{
		case path
		case imageExtension = "extension"
	}
}
