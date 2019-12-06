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
	func inject(presenter: IEntityDetailsPresenter)
	func reloadData()
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
	func showAlert(with text: String)
}

final class EntityDetailsViewController: UIViewController
{
	private var presenter: IEntityDetailsPresenter?

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

	override func loadView() {
		self.view = DetailsView(presenter: presenter)
		self.navigationItem.title = presenter?.getCurrentRecord().showingName
		self.title = presenter?.getCurrentRecord().showingName
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

	func inject(presenter: IEntityDetailsPresenter) {
		self.presenter = presenter
	}
	//Сообщение об ошибке
	func showAlert(with text: String) {
		let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}
