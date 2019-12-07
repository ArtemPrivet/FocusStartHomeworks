//
//  Constants.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
import UIKit

enum InterfaceConstants
{
	static let space: CGFloat = 5
	static let cellHeight: CGFloat = 60
	static let listViewCellIdentifier = "listViewCell"
	static let detailsCellIdentifier = "detailsCell"
	static let tabBarItemImages: [String: String] = [
		"Heroes": "shield",
		"Comics": "comic",
		"Authors": "writer",
	]
}

enum RequestConstants
{
	static let marvelAPIUrl = "https://gateway.marvel.com/v1/public/"
	static let publicKey = "0133174c0832e7c36210d38a43f0a1d5"
	static let privateKey = "69ca4c8f61f9806ef497666a74a2bfc1d701047d"
	static let limit = 100
}
