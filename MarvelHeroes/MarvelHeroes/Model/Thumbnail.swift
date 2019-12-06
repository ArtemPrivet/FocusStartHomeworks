//
//  Thumbnail.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

struct Thumbnail: Decodable
{
	let path: String
	let extensionTitle: String

	private enum CodingKeys: String, CodingKey
	{
		case path
		case extensionTitle = "extension"
	}
}
