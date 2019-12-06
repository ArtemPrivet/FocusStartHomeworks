//
//  ComicDetailsRouter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 05/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class ComicDetailsRouter
{
	weak var comicDetailsView: ComicDetailsView?
	private var factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension ComicDetailsRouter: IComicDetailsRouter
{
	func pushModuleWithAuthorInfo(author: Author) {
		let authorDetailsVC = self.factory.createAuthorDetailsModule(withAuthor: author)
		self.comicDetailsView?.navigationController?.pushViewController(authorDetailsVC,
																		animated: true)
	}
}
