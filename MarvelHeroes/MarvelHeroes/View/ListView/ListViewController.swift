//
//  ListViewController.swift
//  MarvelHeroes
//
//  Created by Stanislav on 08/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

protocol IListViewController
{
	func inject(presenter: IEntityListPresenter)
}

final class ListViewController: UIViewController
{
	private var presenter: IEntityListPresenter?
}

extension ListViewController: IListViewController
{
	func inject(presenter: IEntityListPresenter) {
		self.presenter = presenter
		self.title = presenter.tabTitle
	}
}
