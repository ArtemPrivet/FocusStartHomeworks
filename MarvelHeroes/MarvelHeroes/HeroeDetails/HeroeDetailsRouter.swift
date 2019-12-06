//
//  HeroeDetailsRouter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 03/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class HeroeDetailsRouter
{
	weak var heroeDetailsView: HeroeDetailsView?
	private var factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension HeroeDetailsRouter: IHeroeDetailsRouter
{
	func pushModuleWithComicInfo(comic: Comic) {
		let comicDetailsVC = self.factory.createComicDetailsModule(withComic: comic)
		self.heroeDetailsView?.navigationController?.pushViewController(comicDetailsVC,
																  animated: true)
	}
}
