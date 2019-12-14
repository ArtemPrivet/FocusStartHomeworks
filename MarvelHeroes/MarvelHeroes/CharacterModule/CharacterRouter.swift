//
//  CharacterRouter.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 04.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation

protocol ICharacterRouter
{
	func showDetail(of character: Character)
}

final class CharacterRouter: ICharacterRouter
{
	private let factory: Factory
	weak var viewController: CharacterViewController?

	init(factory: Factory) {
		self.factory = factory
	}

	func showDetail(of character: Character) {
		let detailViewController = factory.getDetailViewController(character: character)
		viewController?.navigationController?.pushViewController(detailViewController, animated: true)
	}
}
