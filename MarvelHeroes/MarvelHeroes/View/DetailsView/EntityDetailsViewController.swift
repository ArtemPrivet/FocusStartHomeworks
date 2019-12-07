//
//  EntityDetailsViewController.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

protocol IEntityDetailsViewController: AnyObject
{
	func inject(presenter: IEntityDetailsPresenter, repository: Repository)
	func reloadData()
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
	func showAlert(with text: String)
}

final class EntityDetailsViewController: UIViewController
{
	private var presenter: IEntityDetailsPresenter?
	private var repository: Repository?

	override func loadView() {
		self.view = DetailsView(presenter: presenter, repository: repository)
		self.navigationItem.title = presenter?.getCurrentRecord().showingName
		self.title = presenter?.getCurrentRecord().showingName
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		if let detailsView = self.view as? IDetailsView {
			detailsView.refreshView()
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if let detailsView = self.view as? IDetailsView {
			detailsView.setGradient()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.triggerViewReadyEvent()
	}
}
// MARK: - IEntityDetailsView
extension EntityDetailsViewController: IEntityDetailsViewController
{
	//Начало анимации спиннера
	func startSpinnerAnimation() {
		if let detailsView = self.view as? IDetailsView {
			detailsView.startSpinnerAnimation()
		}
	}
	//Остановка анимации спиннера
	func stopSpinnerAnimation() {
		if let detailsView = self.view as? IDetailsView {
			detailsView.stopSpinnerAnimation()
		}
	}
	//Обновление данных в таблице
	func reloadData() {
		if let detailsView = self.view as? IDetailsView {
			detailsView.reloadData()
		}
	}

	func inject(presenter: IEntityDetailsPresenter, repository: Repository) {
		self.presenter = presenter
		self.repository = repository
	}
	//Сообщение об ошибке
	func showAlert(with text: String) {
		Alert.simpleAlert.showAlert(with: text, title: "Error", buttonText: "Ok", viewController: self)
	}
}
