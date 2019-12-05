//
//  Thumbnail.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation

struct Thumbnail: Codable
{
	let path: String
	let `extension`: Extension
}

enum Extension: String, Codable
{
	case gif, jpg
}

enum AspectRatio
{

	case portrait(Portrait)
	case standard(Standard)
	case landscape(Landscape)

	var stringValue: String {
		switch self {
		case .portrait(let portrait): return portrait.rawValue
		case .standard(let standard): return standard.rawValue
		case .landscape(let landscape): return landscape.rawValue
		}
	}

	enum Portrait: String
	{
		case small = "portrait_small"
		case medium = "portrait_medium"
		case xlarge = "portrait_xlarge"
		case fantastic = "portrait_fantastic"
		case uncanny = "portrait_uncanny"
		case incredible = "portrait_incredible"
	}

	enum Standard: String
	{
		case small = "standard_small"
		case medium = "standard_medium"
		case xlarge = "standard_xlarge"
		case fantastic = "standard_fantastic"
		case uncanny = "standard_uncanny"
		case incredible = "standard_incredible"
	}

	enum Landscape: String
	{
		case small = "landscape_small"
		case medium = "landscape_medium"
		case xlarge = "landscape_xlarge"
		case fantastic = "landscape_fantastic"
		case uncanny = "landscape_uncanny"
		case incredible = "landscape_incredible"
	}
}

extension Thumbnail
{
	func url(withAspectRatio aspectRatio: AspectRatio) -> URL? {
		URL(string: path)?
			.appendingPathComponent(aspectRatio.stringValue)
			.appendingPathExtension(`extension`.rawValue)
	}
}
