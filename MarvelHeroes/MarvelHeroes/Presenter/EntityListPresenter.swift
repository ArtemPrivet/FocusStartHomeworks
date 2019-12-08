//
//  EntityListPresenter.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation
import UIKit

protocol IEntityListPresenter: AnyObject
{
	var itemTitle: String { get }
	var recordsCount: Int { get }

	func inject(router: IEntityListRouter, repository: Repository, view: IListView)
	func getRecord(index: Int) -> IEntity
	func onCellPressed(index: Int)
	func loadRecords(with nameStarts: String)
	func triggerViewReadyEvent()
}

final class EntityListPresenter
{
	private let title: String
	private let entityType: EntityType
	private weak var view: IListView?
	private var router: IEntityListRouter?
	private var repository: Repository?
	private var records: [IEntity] = []

	init(with entityType: EntityType) {
		self.entityType = entityType
		self.title = entityType.getNavigationTitle()
	}
}

extension EntityListPresenter: IEntityListPresenter
{
	var itemTitle: String {
		return title
	}

	var recordsCount: Int {
		return records.count
	}
	//загрузка данных при прогрузке view
	func triggerViewReadyEvent() {
		loadRecords()
	}
	//Нажатие на ячейку
	func onCellPressed(index: Int) {
		router?.routeToDetails(entity: records[index])
	}
	//Вернуть запись по индексу
	func getRecord(index: Int) -> IEntity {
		return records[index]
	}
	// инжект вью, роутера и репозитория
	func inject(router: IEntityListRouter, repository: Repository, view: IListView) {
		self.view = view
		self.router = router
		self.repository = repository
	}
	//загрузка данных
	func loadRecords(with nameStarts: String = "") {
		self.view?.startSpinnerAnimation()
		let directory = entityType.getEntityDirectory()
		let parameter = entityType.getEntityQueryParameter()

		switch entityType {
		case .character:
			var _: CharacterResponse? = callRequest(directory: directory, parameter: parameter, with: nameStarts)
		case .comics:
			var _: ComicsResponse? = callRequest(directory: directory, parameter: parameter, with: nameStarts)
		case .author:
			var _: AuthorResponse? = callRequest(directory: directory, parameter: parameter, with: nameStarts)
		}
	}
}

private extension EntityListPresenter
{
	func callRequest<T: Decodable>(directory: String, parameter: String, with nameStarts: String) -> T? {
		guard let localRepository = repository else { return nil }
		localRepository.loadEntities(with: nameStarts,
									 directory: directory,
									 queryParameter: parameter){ [weak self] (result: Result<T, ServiceError>) in
										switch result {
										case .success(let response):
											if let data = response as? CharacterResponse {
												self?.records = data.data.results
											}
											if let data = response as? ComicsResponse {
												self?.records = data.data.results
											}
											if let data = response as? AuthorResponse {
												self?.records = data.data.results
											}
											if let count = self?.records.count, count == 0 {
												self?.view?.setEmptyImage(with: nameStarts)
											}
										case .failure(let error):
											error.errorHandler { errorMessage in
												self?.router?.showAlert(with: errorMessage)
											}
											self?.records = []
										}
										self?.view?.reloadData()
										self?.view?.stopSpinnerAnimation()
		}
		return nil
	}
}
