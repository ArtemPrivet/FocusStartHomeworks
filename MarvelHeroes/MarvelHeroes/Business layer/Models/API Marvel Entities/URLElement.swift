//
//  URLElement.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

struct URLElement: Codable
{
	let type: URLType
	let url: String
}

enum URLType: String, Codable
{
	case comiclink, detail, wiki
}
