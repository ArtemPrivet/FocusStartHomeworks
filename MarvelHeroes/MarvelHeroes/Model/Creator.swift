//
//  Creator.swift
//  MarvelHeroes
//
//  Created by Антон on 10.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation

// MARK: - Characters
struct CreatorDataWrapper: Decodable
{
	let code: Int?
	let status, copyright, attributionText, attributionHTML: String?
	let etag: String?
	let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Decodable
{
	let offset, limit, total, count: Int?
	let results: [Creators]?
}

// MARK: - Result
struct Creators: Decodable
{
	let id: Int?
	let firstName, middleName, lastName, suffix: String?
	let fullName: String?
	let thumbnail: Thumbnail?
	let resourceURI: String?
}
struct Thumbnail: Decodable
{
	let path: String?
	let enlargement: String?

	enum CodingKeys: String, CodingKey
	{
		case path = "path"
		case enlargement = "extension"
	}
}

typealias CreatorsResult = Result<CreatorDataWrapper, ServiceError>
