//
//  IComicsView.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 05/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol IComicsView: AnyObject
{
	func reloadData(withComicsCount count: Int)
}
