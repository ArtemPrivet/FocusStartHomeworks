//
//  CharacterViewController.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 02.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import SnapKit

protocol ICharacterViewController: AnyObject
{
	func show(_ characters: [Character])
}

final class CharacterViewController: UIViewController
{
	private let sizeOfTextNothingFoundLabel: CGFloat = 25
	private let sizeOfTextValueNotFoundLabel: CGFloat = 20
	private let placeholderOfSearchBar = "Find character"
	private let titleOfView = "🦸‍♂️ Heroes"

	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}()

	private lazy var searchController: UISearchController = {
		let controller = UISearchController(searchResultsController: nil)
		controller.searchBar.delegate = self
		controller.obscuresBackgroundDuringPresentation = false
		controller.searchBar.placeholder = placeholderOfSearchBar
		self.navigationItem.searchController = controller
		self.definesPresentationContext = true
		return controller
	}()

	private lazy var notFoundImage: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "search_stub"))
		return imageView
	}()

	private lazy var nothingFoundLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textAlignment = .center
		label.textColor = .gray
		label.font.withSize(sizeOfTextNothingFoundLabel)
		label.text = "Nothing found on query"
		label.numberOfLines = 1
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private lazy var valueNotFoundLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textAlignment = .center
		label.textColor = .gray
		label.font.withSize(sizeOfTextValueNotFoundLabel)
		label.text = searchController.searchBar.text
		label.numberOfLines = 1
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private lazy var stackViewForLabel: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [nothingFoundLabel, valueNotFoundLabel])
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fill
		return stackView
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [notFoundImage, stackViewForLabel])
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.backgroundColor = .red
		stackView.distribution = .fill
		stackView.spacing = 50
		stackView.isHidden = true
		return stackView
	}()

	private var characters = [Character]()
	private let presenter: ICharacterPresenter

	init(presenter: ICharacterPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		view.addSubview(stackView)
		updateUI()
		makeConstraints()
	}
}

extension CharacterViewController: ICharacterViewController
{
	func show(_ characters: [Character]) {
		self.characters = characters
		if self.characters.count > 0 {
			self.tableView.reloadData()
		}
		else {
			showNotFound()
		}
	}
}

extension CharacterViewController: UITableViewDataSource, UITableViewDelegate
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return characters.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CharacterCell
		cell?.nameLabel.text = characters[indexPath.row].name
		cell?.descriptionLabel.text = characters[indexPath.row].description.isEmpty
			? "No info"
			: characters[indexPath.row].description

		if let path = characters[indexPath.row].thumbnail.path,
			let imageExtension = characters[indexPath.row].thumbnail.imageExtension {
			let urlString = "\(path).\(imageExtension)"
			presenter.getCharacterImage(imageUrl: urlString) { image in
				cell?.characterImageView.image = image
			}
		}
		return cell ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showDetail(of: characters[indexPath.row])
	}
}

extension CharacterViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchText = searchBar.text, searchText.isEmpty == false else { return }
		presenter.getCharacters(name: searchText)
		tableView.isHidden = false
		stackView.isHidden = true
		self.tableView.reloadData()
	}
}

private extension CharacterViewController
{
	func updateUI() {
		tableView.register(CharacterCell.self, forCellReuseIdentifier: "Cell")
		navigationController?.navigationBar.prefersLargeTitles = true
		title = titleOfView
		view.backgroundColor = .white
	}

	func showNotFound() {
		tableView.isHidden = true
		stackView.isHidden = false
		valueNotFoundLabel.text = searchController.searchBar.text
	}

	func makeConstraints() {

		tableView.snp.makeConstraints { make in
			make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
		}

		notFoundImage.snp.makeConstraints { make in
			make.width.equalTo(182)
			make.height.equalTo(169)
		}

		nothingFoundLabel.snp.makeConstraints { make in
			make.height.equalTo(22)
		}

		valueNotFoundLabel.snp.makeConstraints { make in
			make.height.greaterThanOrEqualTo(22)
		}

		stackViewForLabel.snp.makeConstraints { make in
			make.leading.trailing.equalTo(stackView)
		}

		stackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(30)
			make.centerY.equalToSuperview()
		}
	}
}
