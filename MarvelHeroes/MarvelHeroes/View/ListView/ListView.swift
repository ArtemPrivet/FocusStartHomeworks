//
//  ListView.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

protocol IListView: AnyObject
{
	func reloadData()
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
	func setEmptyImage(with text: String)
}

final class ListView: UIView
{
	private let presenter: IEntityListPresenter
	private let repository: Repository
	private let searchBar = UISearchBar()
	private let table = UITableView()
	private let spinner = UIActivityIndicatorView()
	private var margins = UILayoutGuide()
	private var loaded = false

	init(presenter: IEntityListPresenter, repository: Repository) {
		self.presenter = presenter
		self.repository = repository
		super.init(frame: .zero)
		setupInitialState()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if loaded == false {
			presenter.triggerViewReadyEvent()
		}
		loaded = true
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
// MARK: - IListView protocol
extension ListView: IListView
{
	func reloadData() {
		table.reloadData()
	}

	func stopSpinnerAnimation() {
		spinner.stopAnimating()
		table.isUserInteractionEnabled = true
	}

	func setEmptyImage(with text: String) {
		self.table.backgroundView = StubImageView(messageText: "Nothing found on query \"\(text)\"")
	}

	func startSpinnerAnimation() {
		table.isUserInteractionEnabled = false
		spinner.startAnimating()
	}
}
// MARK: - SearchBar delegate
extension ListView: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchedText = searchBar.text  else { return }
		presenter.loadRecords(with: searchedText)
		self.endEditing(true)
	}
}
// MARK: - tableView delegate
extension ListView: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return InterfaceConstants.cellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.onCellPressed(index: indexPath.row)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
// MARK: - tableView data source
extension ListView: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.recordsCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: InterfaceConstants.listViewCellIdentifier, for: indexPath)
		cell.tag = indexPath.row
		if let customCell = cell as? Cell {
			let record = presenter.getRecord(index: indexPath.row)
			customCell.cellImageView.image = nil
			customCell.cellImageView.makeRound()
			repository.loadImageForCell(imageURL: record.portraitImageURL, completion: { image in
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
// MARK: - Private methods
private extension ListView
{
	func setupInitialState() {
		margins = self.layoutMarginsGuide
		self.backgroundColor = UIColor.white
		setupSearchBar()
		setupTable()
		setupSpinner()
	}
	//Настройка serchBar
	func setupSearchBar() {
		self.addSubview(searchBar)
		searchBar.delegate = self
		searchBar.enablesReturnKeyAutomatically = false
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			searchBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			searchBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			searchBar.topAnchor.constraint(equalTo: margins.topAnchor),
		])
	}
	//Настройка таблицы
	func setupTable() {
		self.addSubview(table)
		table.dataSource = self
		table.delegate = self
		table.register(Cell.self, forCellReuseIdentifier: InterfaceConstants.listViewCellIdentifier)
		table.tableFooterView = UIView()
		table.keyboardDismissMode = .onDrag
		table.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			table.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			table.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			table.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
			table.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
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
}
