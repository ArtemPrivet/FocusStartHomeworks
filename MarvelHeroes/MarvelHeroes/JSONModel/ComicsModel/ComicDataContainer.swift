//
//  ComicDataContainer.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 05.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

struct ComicDataContainer: Decodable
{
	let results: [Comic]?
}
