//
//  Hero.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation
import UIKit

struct HeroesServerResponse: Decodable
{
	let data: HeroesData
}

struct HeroesData: Decodable
{
	let results: [Hero]
}

struct Hero: Decodable
{
	let id: Int
	let name, description: String?
	let thumbnail: Thumbnail

	static let empty = Hero(
		id: 0,
		name: "Error",
		description: "",
		thumbnail: Thumbnail(path: "", thumbnailExtension: ""))
}

extension Hero: IMarvelItemDetails
{
	var title: String? { nil }
	var fullName: String? { nil }
}
