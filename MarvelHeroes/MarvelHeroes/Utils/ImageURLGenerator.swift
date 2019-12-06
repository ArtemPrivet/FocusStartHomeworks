//
//  ImageURLGenerator.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
import Foundation

enum ImageURLGenerator: String
{
	case smallSquare
	case smallPortrait
	case bigSquare

	func getURL(_ link: String, ext: String) -> URL? {
		var modificaror = ""
		switch self {
		case .smallSquare:
			modificaror = "standard_small"
		case .smallPortrait:
			modificaror = "portrait_small"
		case .bigSquare:
			modificaror = "standard_fantastic"
		}
		return URL(string: link.replacingOccurrences(of: "http://i", with: "https://x")
			+ "/\(modificaror).\(ext)")
	}
}
