//
//  IAuthorsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 06/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol IAuthorsPresenter
{
	func getAuthors(withAuthorName name: String?)
	func getAuthorsCount() -> Int
	func getAuthor(at index: Int) -> Author?
	func getAuthorImageData(at index: Int) -> Data
	func onCellPressed(author: Author)
}
