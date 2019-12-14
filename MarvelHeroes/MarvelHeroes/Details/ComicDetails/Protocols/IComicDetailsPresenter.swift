//
//  IComicDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 05/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol IComicDetailsPresenter
{
	func loadData()
	func getComicTitle() -> String?
	func getComicDescription() -> String?
	func getAuthor(at index: Int) -> Author?
	func getAuthorsCount() -> Int
	func getAuthorName(at index: Int) -> String?
	func getAuthorImage(at index: Int) -> Data?
	func pressOnCell(withAuthor author: Author)
}
