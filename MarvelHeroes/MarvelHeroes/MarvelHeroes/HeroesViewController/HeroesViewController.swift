//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit

final class HeroesViewController: UIViewController
{

	let tableView = UITableView()
	private lazy var searchController = UISearchController()
	var presenter: IHeroesPresenter?
	var characters = [Character]()

	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
		tableView.dataSource = self
		// Do any additional setup after loading the view.
		guard let presenter = presenter else { return }
		presenter.getCharacters()
		
	}
	override func loadView() {
		self.view = tableView
	}
	private func configureView(){
		title = "🦸🏻‍♂️ Heroes"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = searchController
	}


}
extension HeroesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print(characters.count)
		return characters.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
		let character = characters[indexPath.row]
		cell.textLabel?.text = character.name
		cell.detailTextLabel?.text = character.description
		presenter?.getCharacterImage(for: character.thumbnail, by: indexPath)
		return cell
	}


}

