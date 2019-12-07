//
//  IComicsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 05/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol IComicsPresenter
{
	func getComics(withComicName name: String?)
	func getComicsCount() -> Int
	func getComic(at index: Int) -> Comic?
	func getComicImageData(at index: Int) -> Data?
	func onCellPressed(comic: Comic)
}
