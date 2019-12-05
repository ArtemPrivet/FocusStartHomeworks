//
//  IItemViewModel.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 03.12.2019.
//

import UIKit

enum ItemType: String, CaseIterable
{
	case charactor = "Heroes"
	case comic = "Comics"
	case creator = "Authors"

	var itemListType: Self {
		switch self {
		case .charactor: return .comic
		case .comic: return .creator
		case .creator: return .comic
		}
	}

	var image: UIImage {
		switch self {
		case .charactor: return #imageLiteral(resourceName: "shield")
		case .comic: return #imageLiteral(resourceName: "comic")
		case .creator:	return #imageLiteral(resourceName: "writer")
		}
	}

	var title: String {
		switch self {
		case .charactor: return "🦸‍♂️ " + rawValue
		case .comic: return "📰 " + rawValue
		case .creator:	return "✍️ " + rawValue
		}
	}
}

protocol IItemViewModel: Decodable
{
	var id: Int { get }
	var title: String { get }
	var description: String? { get }
	var thumbnail: Thumbnail { get }

	var itemType: ItemType { get }
}
