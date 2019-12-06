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
	let name, description: String?
	let thumbnail: Thumbnail
	let resourceURI: String
	let comics: SubItemsCollection

	static let empty = Hero(name: "Error", description: "",
	thumbnail: Thumbnail(path: "", thumbnailExtension: ""), resourceURI: "",
	comics: SubItemsCollection(items: []))
}

extension Hero: IMarvelItemDetails
{
	var subItemsCollection: SubItemsCollection? {
		return comics
	}

	var title: String? { nil }
	var fullName: String? { nil }
}
