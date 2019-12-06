//
//  CharacterImage.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 03.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

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
