//
//  Comics.swift
//  MarvelHeroes
//
//  Created by Антон on 06.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation

struct SeriesDataWrapper: Decodable
{
	let code: Int?
	let status: String?
	let data: SeriesDataContainer?
}
struct SeriesDataContainer: Decodable
{
	let results: [Series]?
}
struct Series: Decodable
{
	let id: Int?
	let title: String?
	let description: String?
	let startYear: String?
	let thumbnail: Image?
}

typealias SeriesResult = Result<SeriesDataWrapper, ServiceError>
