//
//  Hero.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 02.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

struct Character: Decodable
{
	let name: String
	let description: String
	let thumbnail: CharacterImage
}
