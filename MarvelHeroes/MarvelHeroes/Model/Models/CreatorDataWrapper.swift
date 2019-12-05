//
//  CreatorDataWrapper.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

struct CreatorDataWrapper: Decodable {
	let data: CreatorDataContainer
}

struct CreatorDataContainer: Decodable {
	let results: [Creator]
}

struct Creator: Decodable {
	let id: Int
	let firstName: String
	let lastName: String
	let fullName: String?
	let thumbnail: Image
}
