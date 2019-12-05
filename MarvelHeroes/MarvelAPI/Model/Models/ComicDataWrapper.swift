//
//  ComicDataWrapper.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 03.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

struct ComicDataWrapper: Decodable {
	let data: ComicDataContainer
}

struct ComicDataContainer: Decodable {
	let results: [Comic]
}

struct Comic: Decodable {
	let title: String
	let thumbnail: Image
	let description: String?
}
