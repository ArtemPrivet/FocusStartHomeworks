//
//  DetailsCharacterRouter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 03.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IDetailsCharacterRouter
{
	func showDetails(author: Creator)
}

final class DetailsCharacterRouter
{
	weak var detailCharactersView: DetailsCharacterViewController?
	private var factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension DetailsCharacterRouter: IDetailsCharacterRouter
{
	func showDetails(author: Creator) {
		let detailsView = factory.createDetailsVC(author: author)
		detailCharactersView?.navigationController?.pushViewController(detailsView, animated: true)
	}
}
