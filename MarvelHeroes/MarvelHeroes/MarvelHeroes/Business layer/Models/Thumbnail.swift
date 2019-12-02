//
//  Thumbnail.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

struct Thumbnail: Codable {
    let path: String
	let `extension`: Extension
}

enum Extension: String, Codable {
    case gif, jpg
}
