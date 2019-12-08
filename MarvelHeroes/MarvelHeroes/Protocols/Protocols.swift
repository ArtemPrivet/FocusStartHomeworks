//
//  Protocols.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

protocol IDetailPresenter
{
	func getHero() -> ResultChar
	func getComics()
	func countComics() -> Int
	func getComic(of index: Int) -> ResultBook
}

protocol IHeroPresenter
{
	func getHeroes(of text: String)
	func showDetail(of index: Int)
}

protocol IHeroRouter
{
	func showDetail(with hero: ResultChar)
}

protocol IHeroRepository
{
	func getHeroes(of text: String, completion: @escaping([ResultChar]?) -> Void )
}

protocol IComicsrepository
{
	func getComics(of heroID: Int, completion: @escaping([ResultBook]?) -> Void)
}

protocol IHeroView
{
	func show(heroes: [ResultChar])
}

protocol IComicView
{
	func show(comics: [ResultBook])
}
