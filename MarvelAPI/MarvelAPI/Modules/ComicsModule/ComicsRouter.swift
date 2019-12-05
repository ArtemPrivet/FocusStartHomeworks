//
//  ComicsRouter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IComicsRouter {
	func showDetails(comic: Comic)
}

class ComicsRouter {
	
	weak var comicsView: ComicsViewController?
	var factory: Factory
	
	init(factory: Factory) {
		self.factory = factory
	}
}

extension ComicsRouter: IComicsRouter {
	func showDetails(comic: Comic) {
//		let detailsView = factory.createDetailsVC(chracter: comic)
//		comicsView?.navigationController?.pushViewController(detailsView, animated: true)
	}
}
