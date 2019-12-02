//
//  CharacterListViewController.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

// MARK: - ICharacterListViewController Protocol
protocol ICharacterListViewController: AnyObject {
	func showCharacters(_ characters: [Character])
	func showAlert()
}

// MARK: - Class
class CharacterListViewController: UIViewController {

	// MARK: Private properties
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .yellow
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}()

	private lazy var resultSearchController: UISearchController = {
		let controller = UISearchController(searchResultsController: nil)
		controller.searchResultsUpdater = self
		controller.obscuresBackgroundDuringPresentation = false
		controller.searchBar.placeholder = "Start typing character..."
		self.navigationItem.searchController = controller
		self.definesPresentationContext = true
		return controller
	}()

	private var isSearchBarEmpty: Bool {
		resultSearchController.searchBar.text?.isEmpty ?? true
	}

	private var characters = [Character]()

	private var timer = Timer()
	private let presenter: ICharactersPresenter

	// MARK: Initialization
	init(presenter: ICharactersPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heroes"

		view.addSubview(tableView)
		_ = resultSearchController.searchBar
		setConstraints()

		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.topItem?.title = "Hello"
		navigationController?.navigationItem.largeTitleDisplayMode = .automatic

		tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 100
    }

	// MARK: Private methods
	private func setConstraints() {
		var selfView: UILayoutGuide
 		if #available(iOS 11.0, *) {
 			selfView = self.view.safeAreaLayoutGuide
 		} else {
 			selfView = self.view.layoutMarginsGuide
 		}
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.leadingAnchor.constraint(equalTo: selfView.leadingAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: selfView.topAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: selfView.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: selfView.bottomAnchor).isActive = true
	}
}

// MARK: - ICharacterListViewController
extension CharacterListViewController: ICharacterListViewController {
	func showCharacters(_ characters: [Character]) {
		self.characters = characters
		tableView.reloadData()
		print("---")
	}

	func showAlert() {
		print("ERROR")
	}

}

// MARK: - Search results updating
extension CharacterListViewController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text ?? "")
	}

	private func filterContentForSearchText(_ searchText: String) {
		presenter.performLoadCharacters(after: 0.7, with: searchText)
	}
}

// MARK: - Table view data source
extension CharacterListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		characters.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CharacterTableViewCell
		//let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
			//?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

//		let link = characters[indexPath.row].thumbnail.path + "." + characters[indexPath.row].thumbnail.extension.rawValue
//		if cell.imageView?.image == nil {
//			cell.imageView?.image = #imageLiteral(resourceName: "placeholder")
//		} else {
//			cell.imageView?.downloadImageFrom(link: link, contentMode: .scaleAspectFit)
//			presenter.loadImage(from: characters[indexPath.row].thumbnail.path,
//								extension: characters[indexPath.row].thumbnail.extension.rawValue) {
//				cell.imageView?.image = $0
//			}
//		}
//		cell.accessoryType = .disclosureIndicator
//		cell.textLabel?.text = characters[indexPath.row].name
//		cell.detailTextLabel?.text = characters[indexPath.row].resourceURI
		cell?.configure(using: characters[indexPath.row])

		presenter
			.onThumnailUpdate(
				by: characters[indexPath.row].thumbnail.path,
				extension: characters[indexPath.row].thumbnail.extension.rawValue) { image in
					guard let image = image else { return }
					cell?.updateIcon(image: image)
		}

        return cell ?? UITableViewCell()
	}
}

// MARK: - Table view delegate
extension CharacterListViewController: UITableViewDelegate {

}
