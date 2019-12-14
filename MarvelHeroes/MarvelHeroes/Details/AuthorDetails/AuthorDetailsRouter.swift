//
//  AuthorDetailsRouter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 06/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class AuthorDetailsRouter
{
	weak var authorDetailsView: AuthorDetailsViewController?
	private var factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension AuthorDetailsRouter: IAuthorDetailsRouter
{
	func pushModuleWithComicInfo(comic: Comic) {
		let comicDetailsVC = self.factory.createComicDetailsModule(withComic: comic)
		self.authorDetailsView?.navigationController?.pushViewController(comicDetailsVC,
																		animated: true)
	}
}
