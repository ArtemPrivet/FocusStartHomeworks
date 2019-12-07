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
	func inject(presenter: IEntityListPresenter, repository: Repository)
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
	func setEmptyImage(with text: String)
	func showAlert(with text: String)
}

final class EntityListViewController: UIViewController
{
	private var presenter: IEntityListPresenter?
	private var repository: Repository?

	override func loadView() {
		self.view = ListView(presenter: presenter, repository: repository)
		navigationController?.navigationBar.prefersLargeTitles = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = presenter?.itemTitle
		presenter?.triggerViewReadyEvent()
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
	func inject(presenter: IEntityListPresenter, repository: Repository) {
		self.presenter = presenter
		self.repository = repository
	}
	//Обновление данных в таблице
	func reloadData() {
		if let listView = self.view as? IListView {
			listView.reloadData()
		}
	}
	//Сообщение об ошибке
	func showAlert(with text: String) {
		Alert.simpleAlert.showAlert(with: text, title: "Error", buttonText: "Ok", viewController: self)
	}
}
