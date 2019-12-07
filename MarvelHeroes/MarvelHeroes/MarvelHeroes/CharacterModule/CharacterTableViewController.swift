//
//  TableViewController.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 02.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit

class CharacterTableViewController: UITableViewController {

	var response1: Response1!
	var results = [Results]()
	var jsonService: IJsonService!
	var loadData = LoadData()

	init(jsonService: IJsonService) {
		self.jsonService = jsonService
		super.init(style: .plain)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		print(Date().timeIntervalSince1970)

		jsonService.loadResult(urlString: "https://gateway.marvel.com/v1/public/characters?nameStartsWith=Spider&ts=1575402957.5362449&apikey=7e95fcb24f48e6f5664a04ab87cb1083&hash=0d2a236c63d9736e6fb00f53bcdeab01&limit=100&offset=0") { [weak self] characterResult in
		guard let self = self else { return }
		switch characterResult {
		case .success(let result):
			//print(result)
			self.results = result.data.results
			//print(self.results)
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
			case .failure(let error):
			assertionFailure(error.localizedDescription)
		}
			//self.tableView.reloadData()
		}
		//self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return results.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
			//tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
		cell.textLabel?.text = results[indexPath.row].name
		print(cell.textLabel?.text)
		cell.detailTextLabel?.text = results[indexPath.row].description

        // Configure the cell...

        return cell
    }
}
