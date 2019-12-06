//
//  NetworkServiceError.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error
{
	case sessionError(Error)
	case dataError(Error)
	case clientError(Int)
	case serverError(Int)
}
