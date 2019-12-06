//
//  IAuthorDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 06/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol IAuthorDetailsPresenter
{
	func loadData()
	func getAuthorName() -> String?
	func getComic(at index: Int) -> Comic?
	func getComicsCount() -> Int
	func getComicTitle(at index: Int) -> String?
	func getComicImage(at index: Int) -> Data?
	func pressOnCell(withComic comic: Comic)
}
