//
//  ComicsRouter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class ComicsRouter
{
	weak var comicsView: ComicsViewController?
	private var factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension ComicsRouter: IComicsRouter
{
	func pushModuleWithComicInfo(comic: Comic) {
		let comicDetailsVC = self.factory.createComicDetailsModule(withComic: comic)
		self.comicsView?.navigationController?.pushViewController(comicDetailsVC,
																  animated: true)
	}
}
