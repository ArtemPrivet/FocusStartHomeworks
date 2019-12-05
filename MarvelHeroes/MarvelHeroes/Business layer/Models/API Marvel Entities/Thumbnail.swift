//
//  Thumbnail.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation

struct Thumbnail: Codable
{
	let path: String
	let `extension`: Extension
}

enum Extension: String, Codable
{
	case gif, jpg
}

extension Thumbnail
{
	var url: URL? {
		URL(string: path)?.appendingPathExtension(`extension`.rawValue)
	}
}
