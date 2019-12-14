//
//  Constants.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

enum TableViewConstants
{
	static let tableViewCellHeight = CGFloat(64)
	static let tableViewCellLeftInset = CGFloat(16)
	static let tableViewCellRightInset = CGFloat(-16)
	static let tableViewCellImageSize = CGFloat(44)
	static let tableViewCellImageHeight = CGFloat(56)
	static let tableViewCellImageWidth = CGFloat(42)
	static let tableViewCellSpaceBetweenElements = CGFloat(16)
}

enum Insets
{
	static let topInset = CGFloat(24)
	static let bottomInset = CGFloat(-16)
	static let leftInset = CGFloat(16)
	static let rightInset = CGFloat(-16)

	static let topInsetLabelHeroesNotFound = CGFloat(8)
	static let topInsetLabelComicsNotFound = CGFloat(8)
}

enum URLConstants
{
	static let scheme = "https"
	static let marvelURL = "gateway.marvel.com"
	static let charactersURL = "/v1/public/characters"
	static let comicsURL = "/v1/public/comics"
	static let authorsURL = "/v1/public/creators"
}

enum APIKeys
{
	static let publicKey = "8dbc459c0bee5b5e80c0e15a60c65c6d"
	static let privateKey = "56213628366ea053b174612ba92d2ab3459215e7"
}

enum Size
{
	static let imageViewHeroesNotFound = CGFloat(200)
	static let imageViewComicsNotFound = CGFloat(150)
}

enum ImageSize
{
	static let medium = "/standard_medium."
	static let portrait = "/portrait_uncanny."
	static let portraitSmall = "/portrait_small."
}

enum URLKeysConstants
{
	static let titleStartsWith = "titleStartsWith"
	static let nameStartsWith = "nameStartsWith"
	static let timestamp = "ts"
	static let apikey = "apikey"
	static let hash = "hash"
	static let limit = "limit"
}

enum Fonts
{
	static let helvetica16 = UIFont(name: "Helvetica", size: 16)
	static let helvetica18 = UIFont(name: "Helvetica", size: 18)
	static let helvetica20 = UIFont(name: "Helvetica", size: 20)
	static let helvetica22 = UIFont(name: "Helvetica", size: 22)
	static let helveticaBold36 = UIFont(name: "Helvetica-Bold", size: 36)
}

enum Titles
{
	static let heroesTitle = "🦸🏼‍♂️Heroes"
	static let comicsTitle = "📚Comics"
	static let authorsTitle = "👨🏼‍🏫Authors"
}
