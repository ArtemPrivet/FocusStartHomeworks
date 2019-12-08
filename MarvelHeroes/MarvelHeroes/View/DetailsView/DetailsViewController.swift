//
//  DetailsViewController.swift
//  MarvelHeroes
//
//  Created by Stanislav on 08/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

protocol IDetailsViewController
{
	func inject(presenter: IEntityDetailsPresenter)
}

final class DetailsViewController: UIViewController
{
	private var presenter: IEntityDetailsPresenter?
}

extension DetailsViewController: IDetailsViewController
{
	func inject(presenter: IEntityDetailsPresenter) {
		self.presenter = presenter
		self.title = presenter.currentRecord.showingName
	}
}
