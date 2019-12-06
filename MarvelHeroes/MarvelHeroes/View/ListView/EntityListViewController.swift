//
//  EntityListViewController.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

protocol IEntityListViewController: AnyObject
{
	func reloadData()
	func inject(presenter: IEntityListPresenter)
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
	func setEmptyImage(with text: String)
	func showAlert(with text: String)
}

final class EntityListViewController: UIViewController
{
	private var presenter: IEntityListPresenter?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = presenter?.getTitle()
		presenter?.triggerViewReadyEvent()
	}

	override func loadView() {
		self.view = ListView(presenter: presenter)
	}
}

// MARK: - IEntityListView
extension EntityListViewController: IEntityListViewController
{
	//Установить картинку если нет результатов поиска
	func setEmptyImage(with text: String) {
		if let listView = self.view as? IListView {
			listView.setEmptyImage(with: text)
		}
	}
	//Начало анимации спиннера
	func startSpinnerAnimation() {
		if let listView = self.view as? IListView {
			listView.startSpinnerAnimation()
		}
	}
	//Остановка анимации спиннера
	func stopSpinnerAnimation() {
		if let listView = self.view as? IListView {
			listView.stopSpinnerAnimation()
		}
	}
	//инжект
	func inject(presenter: IEntityListPresenter) {
		self.presenter = presenter
	}
	//Обновление данных в таблице
	func reloadData() {
		if let listView = self.view as? IListView {
			listView.reloadData()
		}
	}

	func showAlert(with text: String) {
		let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}
