//
//  TableViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

	let marvel = MarvelApiService()
	
	var characters: CharacterDataWrapper?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		
		var components = URLComponents(string: "https://gateway.marvel.com/v1/public/characters?")
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constans.timestamp),
//			URLQueryItem(name: "nameStartsWith", value: "sp"),
			URLQueryItem(name: "limit", value: "10"),
			URLQueryItem(name: "apikey", value: Constans.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]

		let url = components?.url
		
		marvel.loadCharacters(url: url!) { CharactersResult in
			switch CharactersResult {
			case .success(let charcters):
				self.characters = charcters
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			case .failure(let error):
				print(error.localizedDescription)
				assertionFailure(error.localizedDescription)
			}
		}
	}

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		guard let count = characters?.data.results.count else { return 0 }
		return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

		if let character = characters?.data.results[indexPath.row] {
			cell.textLabel?.text = character.name
			cell.detailTextLabel?.text = character.description
		}
        return cell
    }
}
