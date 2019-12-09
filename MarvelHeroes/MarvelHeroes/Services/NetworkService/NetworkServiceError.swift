//
//  NetworkServiceError.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error
{
	case wrongURL
	case serverError(Error)
	case noData
	case wrongData
	case decode(Error)
	case encode(Error)
	case noHTTPResponse
	case clientError
	case serverResponseError
	case tooManyRequests
}
