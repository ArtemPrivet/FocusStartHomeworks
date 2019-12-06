//
//  IHeroeDetailsView.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 03/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

protocol IHeroeDetailsView: AnyObject
{
	func showData(withImageData data: Data?, withComicsCount count: Int)
}
