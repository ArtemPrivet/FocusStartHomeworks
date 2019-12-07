//
//  ComicsRouter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IComicsRouter
{
	func showDetails(comics: Comic)
}

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
	func showDetails(comics: Comic) {
		let detailsView = factory.createDetailsVC(comics: comics)
		comicsView?.navigationController?.pushViewController(detailsView, animated: true)
	}
}
