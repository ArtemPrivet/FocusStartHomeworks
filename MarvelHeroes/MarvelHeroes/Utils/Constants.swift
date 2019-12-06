//
//  Constants.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
import UIKit

enum Constants
{
	static let space: CGFloat = 5
	static let cellHeight: CGFloat = 60
	static let tabBarItemImages: [String: String] = [
		"Heroes": "shield",
		"Comics": "comic",
		"Authors": "writer",
	]
	static let marvelAPIUrl = "https://gateway.marvel.com/v1/public/"
	static let publicKey = "0133174c0832e7c36210d38a43f0a1d5"
	static let hash = "e18f163d3a1c61b5e8aa43119c235a44"
	static let ts = "stanislav"
	static let limit = 100
}
