//
//  EntityListPresenter.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
//swiftlint:disable function_body_length

import Foundation

protocol IEntityListPresenter: AnyObject
{
	func inject(view: IEntityListViewController, router: IEntityListRouter, repository: Repository)
	func getRecordsCount() -> Int
	func getRecord(index: Int) -> IEntity
	func onCellPressed(index: Int)
	func loadRecords(with nameStarts: String)
	func triggerViewReadyEvent()
	func getTitle() -> String
}

final class EntityListPresenter
{
	private weak var view: IEntityListViewController?
	private var router: IEntityListRouter?
	private var repository: Repository?
	private var records: [IEntity] = []
	private let title: String
	private var entityType: EntityType

	init(with entityType: EntityType) {
		self.entityType = entityType
		self.title = entityType.getNavigationTitle()
	}
}

extension EntityListPresenter: IEntityListPresenter
{
	//Текущий заголовок
	func getTitle() -> String {
		return title
	}
	//загрузка данных при прогрузке view
	func triggerViewReadyEvent() {
		loadRecords()
	}
	//Нажатие на ячейку
	func onCellPressed(index: Int) {
		router?.routeToDetails(entity: records[index])
	}
	//Количество записей
	func getRecordsCount() -> Int {
		return records.count
	}
	//Вернуть запись по индексу
	func getRecord(index: Int) -> IEntity {
		return records[index]
	}
	// инжект вью, роутера и репозитория
	func inject(view: IEntityListViewController, router: IEntityListRouter, repository: Repository) {
		self.view = view
		self.router = router
		self.repository = repository
	}
	//загрузка данных
	func loadRecords(with nameStarts: String = "") {
		guard let localRepository = repository else { return }
		self.view?.startSpinnerAnimation()
		let directory = entityType.getEntityDirectory()
		let parameter = entityType.getEntityQueryParameter()
		switch entityType {
		case .character:
			localRepository.loadEntities(with: nameStarts,
										 directory: directory,
										 queryParameter: parameter){ (result: Result<CharacterResponse, NSError>) in
											switch result {
											case .success(let responseCharacters):
												self.records = responseCharacters.data.results
												if self.records.isEmpty {
													self.view?.setEmptyImage(with: nameStarts)
												}
											case .failure(let error):
												print(error)
												self.records = []
											}
											self.view?.reloadData()
											self.view?.stopSpinnerAnimation()
			}
		case .comics:
			localRepository.loadEntities(with: nameStarts,
										 directory: directory,
										 queryParameter: parameter){ (result: Result<ComicsResponse, NSError>) in
											switch result {
											case .success(let responseCharacters):
												self.records = responseCharacters.data.results
												if self.records.isEmpty {
													self.view?.setEmptyImage(with: nameStarts)
												}
											case .failure(let error):
												print(error)
												self.records = []
											}
											self.view?.reloadData()
											self.view?.stopSpinnerAnimation()
			}
		case .author:
			localRepository.loadEntities(with: nameStarts,
										 directory: directory,
										 queryParameter: parameter){ (result: Result<AuthorResponse, NSError>) in
											switch result {
											case .success(let responseCharacters):
												self.records = responseCharacters.data.results
												if self.records.isEmpty {
													self.view?.setEmptyImage(with: nameStarts)
												}
											case .failure(let error):
												print(error)
												self.records = []
											}
											self.view?.reloadData()
											self.view?.stopSpinnerAnimation()
			}
		}
	}
}
