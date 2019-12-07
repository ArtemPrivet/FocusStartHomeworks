//
//  AuthorsRouter.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IAuthorRouter
{
	func showDetails(author: Creator)
}

final class AuthorRouter
{

	weak var authorView: AuthorsViewController?
	private var factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension AuthorRouter: IAuthorRouter
{
	func showDetails(author: Creator) {
		let detailsView = factory.createDetailsVC(author: author)
		authorView?.navigationController?.pushViewController(detailsView, animated: true)
	}
}
