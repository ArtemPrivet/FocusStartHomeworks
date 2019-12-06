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
	func inject(presenter: IEntityDetailsPresenter)
	func reloadData()
	func startSpinnerAnimation()
	func stopSpinnerAnimation()
	func setGradient()
	func refreshView()
}

final class DetailsView: UIView
{
	private var presenter: IEntityDetailsPresenter?
	private var descriptionTextView = UITextView()
	private var table = UITableView()
	private var backgroundImageView = UIImageView()
	private var margins = UILayoutGuide()
	private var spinner = UIActivityIndicatorView()
	private var space = Constants.space

	init(presenter: IEntityDetailsPresenter?) {
		super.init(frame: .zero)
		self.presenter = presenter

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

	func inject(presenter: IEntityDetailsPresenter) {
		self.presenter = presenter
		refreshData()
	}
}
// MARK: - TableView dataSource
extension DetailsView: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.getRecordsCount() ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "comicsCell", for: indexPath)
		if let customCell = cell as? Cell, let record = presenter?.getRecord(index: indexPath.row) {
			customCell.imageURL = record.portraitImageURL
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
		return Constants.cellHeight
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
		loadBackgroundImage()
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
	//Настройка списка комиксов tableView
	func setupTableView() {
		table.register(Cell.self, forCellReuseIdentifier: "comicsCell")
		table.tableFooterView = UIView()
		table.dataSource = self
		table.delegate = self
		self.addSubview(table)
		table.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			table.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
			table.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor),
			table.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: space),
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
	func loadBackgroundImage() {
		backgroundImageView.image = nil
		let imageURL = presenter?.getCurrentRecord().bigImageURL
		if let url = imageURL {
			if let imageFromCache = Cache.imageCache.object(forKey: url as AnyObject) as? UIImage {
				backgroundImageView = UIImageView(image: imageFromCache)
			}
			else {
				DispatchQueue.global(qos: .utility).async {
					let contentsOfURL = try? Data(contentsOf: url)
					DispatchQueue.main.async {
						if url == imageURL {
							if let imageData = contentsOfURL, let image = UIImage(data: imageData)  {
								Cache.imageCache.setObject(image, forKey: url as AnyObject)
								self.backgroundImageView.image = image
							}
						}
					}
				}
			}
		}
	}
}
