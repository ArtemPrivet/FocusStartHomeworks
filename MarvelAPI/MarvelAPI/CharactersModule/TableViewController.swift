//
//  TableViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

	let marvelService: IMarvelApiService
	let image: UIImage? = nil
	var characters: [Character] = []
	
	init(marvelService: IMarvelApiService) {
		self.marvelService = marvelService
		super.init(style: .plain)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		
		var components = URLComponents(string: "https://gateway.marvel.com/v1/public/characters?")
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "10"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]

		let url = components?.url
		
		marvelService.loadCharacters(url: url!) { CharactersResult in
			switch CharactersResult {
			case .success(let characterDataWrapper):
				self.characters = characterDataWrapper.data.results
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
		return characters.count
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
		
		let character = characters[indexPath.row]
		cell.textLabel?.text = character.name
		cell.detailTextLabel?.text = character.description
		
		marvelService.loadCharcterImage(urlString:String.getUrlString(path: character.thumbnail.path,
								variant: ThumbnailVarians.standardSmall,
								extension: character.thumbnail.extension)) { imageResult in
			 switch imageResult {
			 case .success(let image):
				 DispatchQueue.main.async {
					cell.imageView?.image = image
					cell.layoutSubviews()
				 }
			 case .failure(let error):
				 print(error.localizedDescription)
			 }
		}
		return cell
	}
}
