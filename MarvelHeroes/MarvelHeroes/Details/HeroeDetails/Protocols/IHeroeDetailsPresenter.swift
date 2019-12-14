//
//  IHeroeDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 03/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol IHeroeDetailsPresenter
{
	func loadData()
	func getHeroeName() -> String?
	func getHeroeDescription() -> String?
	func getComicsCount() -> Int
	func getComic(at index: Int) -> Comic?
	func getComicTitle(at index: Int) -> String?
	func getComicImage(at index: Int) -> Data?
	func pressOnCell(withComic comic: Comic)
}
