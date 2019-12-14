//
//  Router.swift
//  MarvelHeroes
//
//  Created by Антон on 10.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation
protocol IRouter
{
	func showDetail(model: StructForPresenterArray, presenterType: PresenterType)
	func showDetailForDetailViewController(detailViewController: DetailViewController,
										   model: StructForPresenterArray,
										   presenterType: PresenterType)
}

final class Router
{
	weak var mainViewController: MainScreenViewController?
}
extension Router: IRouter
{
	func showDetail(model: StructForPresenterArray, presenterType: PresenterType) {
		let detailpresenter = DetailPresenter(model: model, presenterType: presenterType)
		let detailVC = DetailViewController(detailPresenter: detailpresenter)
		mainViewController?.navigationController?.pushViewController(detailVC, animated: true)
	}

	func showDetailForDetailViewController(detailViewController: DetailViewController,
										   model: StructForPresenterArray,
										   presenterType: PresenterType) {
		let presenter = DetailPresenter(model: model, presenterType: presenterType)
		let detailVC = DetailViewController(detailPresenter: presenter)
		detailViewController.navigationController?.pushViewController(detailVC, animated: true)
	}
}
