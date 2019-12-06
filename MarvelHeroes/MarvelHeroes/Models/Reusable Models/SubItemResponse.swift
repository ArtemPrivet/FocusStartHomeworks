//
//  SubItemResponse.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 06.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation

struct SubItemResponse: Decodable
{
	let data: SubItemResults
}

struct SubItemResults: Decodable
{
	let results: [SubItemResult]
}

struct SubItemResult: Decodable
{
	let title: String?
	let fullName: String?
	let description: String?
	let thumbnail: Thumbnail
	let resourceURI: String
	let creators: SubItemsCollection?
	let comics: SubItemsCollection?
}
