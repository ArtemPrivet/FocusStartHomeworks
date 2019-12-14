//
//  ServiceError.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 02.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

enum ServiceError: Error
{
	case sessionError(Error)
	case notFound(Error)
	case dataError(Error)
	case statusCode(Int)
}
