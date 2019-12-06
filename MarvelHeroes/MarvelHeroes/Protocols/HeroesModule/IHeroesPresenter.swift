//
//  IHeroesPresenterProtocol.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol IHeroesPresenter
{
	func getHeroes(withHeroeName name: String?)
	func getHeroesCount() -> Int
	func getHeroe(at index: Int) -> Heroe?
	func getHeroeImageData(at index: Int) -> Data
	func onCellPressed(heroe: Heroe)
}
