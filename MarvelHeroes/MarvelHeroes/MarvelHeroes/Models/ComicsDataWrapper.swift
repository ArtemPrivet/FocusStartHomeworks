//
//  ComicsDataWrapper.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 07/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

struct ComicsDataWrapper: Decodable
{
	let data: ComicsDataContainer
}

struct ComicsDataContainer: Decodable
{
	let results: [Comics]
}

struct Comics: Decodable
{
	let id: Int
	let title: String
	let thumbnail: Image
	let description: String?
}
