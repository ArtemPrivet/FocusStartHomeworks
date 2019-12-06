//
//  SubItemsCollection.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 06.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation

struct SubItemsCollection: Decodable
{
	let items: [SubItem]
}

struct SubItem: Decodable
{
	let resourceURI: String
	let name: String
}
