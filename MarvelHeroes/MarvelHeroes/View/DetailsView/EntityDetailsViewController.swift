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
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
		self.navigationItem.title = presenter?.getCurrentRecord().showingName
	}
}
// MARK: - IEntityDetailsView
extension EntityDetailsViewController: IEntityDetailsViewController
{
	func startSpinnerAnimation() {
		if let detailsView = self.view as? IDetailsView {
			detailsView.startSpinnerAnimation()
		}
	}

	func stopSpinnerAnimation() {
		if let detailsView = self.view as? IDetailsView {
			detailsView.stopSpinnerAnimation()
		}
	}

	func reloadData() {
		if let detailsView = self.view as? IDetailsView {
			detailsView.reloadData()
		}
	}

	func inject(presenter: IEntityDetailsPresenter) {
		self.presenter = presenter
	}

	func showAlert(with text: String) {
		let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}
