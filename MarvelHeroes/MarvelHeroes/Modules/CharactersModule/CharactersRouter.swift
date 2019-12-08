//
//  CharactersRouter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol ICharactersRouter
{
	func showDetails(character: Character)
}

final class CharactersRouter
{

	weak var charactersView: CharactersViewController?
	private let factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension CharactersRouter: ICharactersRouter
{
	func showDetails(character: Character) {
		let detailsView = factory.createDetailsVC(chracter: character)
		charactersView?.navigationController?.pushViewController(detailsView, animated: true)
	}
}
