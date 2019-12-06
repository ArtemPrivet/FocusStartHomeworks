//
//  AuthorsRouter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class AuthorsRouter
{
	weak var authorsView: AuthorsView?
	private var factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension AuthorsRouter: IAuthorsRouter
{
	func pushModuleWithAuthorInfo(author: Author) {
		let authorDetailsVC = self.factory.createAuthorDetailsModule(withAuthor: author)
		self.authorsView?.navigationController?.pushViewController(authorDetailsVC,
																  animated: true)
	}
}
