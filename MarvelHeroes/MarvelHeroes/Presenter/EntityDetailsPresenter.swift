//
//  EntityDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

protocol IEntityDetailsPresenter: AnyObject
{
	func inject(view: IEntityDetailsViewController, router: IEntityDetailsRouter, repository: Repository)
	func getCurrentRecord() -> IEntity
	func onAccessoryPressed(index: Int)
	func triggerViewReadyEvent()
	func getRecordsCount() -> Int
	func getRecord(index: Int) -> IEntity
}

final class EntityDetailsPresenter
{
	private weak var view: IEntityDetailsViewController?
	private var router: IEntityDetailsRouter?
	private var currentRecord: IEntity
	private var accesories: [IEntity] = []
	private var repository: Repository?
	private var entityType: EntityType

	init(entity: IEntity, with entityType: EntityType) {
		self.currentRecord = entity
		self.entityType = entityType
	}
}

extension EntityDetailsPresenter: IEntityDetailsPresenter
{
	//Текущая запись
	func getRecord(index: Int) -> IEntity {
		return accesories[index]
	}
	//Количество записей
	func getRecordsCount() -> Int {
		return accesories.count
	}
	//загрузка данных при прогрузке view
	func triggerViewReadyEvent() {
		loadAccessoryByEntityID()
	}
	//Нажатие на ячейку
	func onAccessoryPressed(index: Int) {
		router?.routeToAccessory(accessory: accesories[index])
	}
	// инжект вью, роутера и репозитория
	func inject(view: IEntityDetailsViewController, router: IEntityDetailsRouter, repository: Repository) {
		self.view = view
		self.router = router
		self.repository = repository
	}
	//вернуть текущю запись
	func getCurrentRecord() -> IEntity {
		return currentRecord
	}
}

private extension EntityDetailsPresenter
{
	//Загрузка дополнительных данных для текущей записи
	func loadAccessoryByEntityID() {
		guard let localRepository = repository else { return }
		view?.startSpinnerAnimation()
		let directory = entityType.directoryOfAccessories(id: currentRecord.id)
		switch entityType {
		case .character, .author:
			localRepository.loadAccessoryByEntityID(from: directory) {(result: Result<ComicsResponse, NSError>) in
				switch result {
				case .success(let accessories):
					self.accesories = accessories.data.results
				case .failure(let error):
					self.accesories = []
					print(error)
				}
				self.view?.reloadData()
				self.view?.stopSpinnerAnimation()
			}
		case .comics:
			localRepository.loadAccessoryByEntityID(from: directory) {(result: Result<AuthorResponse, NSError>) in
				switch result {
				case .success(let accessories):
					self.accesories = accessories.data.results
				case .failure(let error):
					self.accesories = []
					print(error)
				}
				self.view?.reloadData()
				self.view?.stopSpinnerAnimation()
			}
		}
	}
}
