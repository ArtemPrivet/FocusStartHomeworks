//
//  DetailsView.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

protocol IDetailsView: AnyObject
{
	func inject(presenter: IEntityDetailsPresenter, repository: Repository)
	func reloadData()
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
	func setGradient()
	func refreshView()
}

final class DetailsView: UIView
{
	private var presenter: IEntityDetailsPresenter?
	private var repository: Repository?
	private let descriptionTextView = UITextView()
	private let table = UITableView()
	private let backgroundImageView = UIImageView()
	private let spinner = UIActivityIndicatorView()
	private var margins = UILayoutGuide()

	init(presenter: IEntityDetailsPresenter?, repository: Repository?) {
		super.init(frame: .zero)
		self.presenter = presenter
		self.repository = repository

		setupInitialState()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
// MARK: - IDetailsView
extension DetailsView: IDetailsView
{
	func setGradient() {
		backgroundImageView.setWhiteGradientAbove()
	}

	func startSpinnerAnimation() {
		spinner.startAnimating()
	}

	func stopSpinnerAnimation() {
		spinner.stopAnimating()
	}

	func reloadData() {
		table.reloadData()
	}

	func refreshView() {
		refreshData()
	}

	func inject(presenter: IEntityDetailsPresenter, repository: Repository) {
		self.presenter = presenter
		self.repository = repository
		refreshData()
	}
}
// MARK: - TableView dataSource
extension DetailsView: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.recordsCount ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: InterfaceConstants.detailsCellIdentifier,
												 for: indexPath)
		if let customCell = cell as? Cell, let record = presenter?.getRecord(index: indexPath.row) {
			customCell.tag = indexPath.row
			repository?.loadImageForCell(imageURL: record.portraitImageURL, completion: { image in
				if customCell.tag == indexPath.row {
					customCell.cellImageView.image = image
				}
			})
			customCell.cellTitle.text = record.showingName
			customCell.cellDetails.text = record.description
		}
		return cell
	}
}
// MARK: - TableView delegate
extension DetailsView: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return InterfaceConstants.cellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.onAccessoryPressed(index: indexPath.row)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
// MARK: - Private methods
private extension DetailsView
{
	//Настройка первоначального состояния view
	func setupInitialState() {
		margins = self.layoutMarginsGuide
		self.backgroundColor = .white
		setupTextView()
		setupTableView()
		setupBackground()
		self.addSubview(spinner)
		setupSpinner()
	}
	//Обновляем поля данными из презентера
	func refreshData() {
		descriptionTextView.text = presenter?.getCurrentRecord().description
		setBackgroundImage()
		table.reloadData()
		let beginPosition = descriptionTextView.beginningOfDocument
		descriptionTextView.selectedTextRange = descriptionTextView.textRange(from: beginPosition,
																			  to: beginPosition)
	}
	//Настройка textView
	func setupTextView() {
		descriptionTextView.font = UIFont.systemFont(ofSize: 20)
		descriptionTextView.isEditable = false
		descriptionTextView.backgroundColor = .clear
		self.addSubview(descriptionTextView)
		descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			descriptionTextView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20 ),
			descriptionTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			descriptionTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			descriptionTextView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.5),
		])
	}
	//Настройка  tableView
	func setupTableView() {
		table.register(Cell.self, forCellReuseIdentifier: InterfaceConstants.detailsCellIdentifier)
		table.tableFooterView = UIView()
		table.dataSource = self
		table.delegate = self
		self.addSubview(table)
		table.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			table.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
			table.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor),
			table.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: InterfaceConstants.space),
			table.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
		])
	}
	//Настройка бэкграунда для описания героя
	func setupBackground() {
		backgroundImageView.contentMode = .scaleAspectFill
		self.insertSubview(backgroundImageView, at: 0)
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
			backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			backgroundImageView.bottomAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
		])
	}
	//Настройка спиннера
	func setupSpinner() {
		self.addSubview(spinner)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			spinner.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
		])
	}
	//загружаем картинку для бэкграунда
	func setBackgroundImage() {
		backgroundImageView.image = nil
		repository?.loadBackgroundImage(imageURL: presenter?.getCurrentRecord().bigImageURL, completion: { image in
			self.backgroundImageView.image = image
		})
	}
}
