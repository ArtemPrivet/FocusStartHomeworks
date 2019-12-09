//
//  NetworkServiceProtocols.swift
//  
//
//  Created by Михаил Медведев on 26/07/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//  swiftlint:disable function_parameter_count

import UIKit

protocol NetworkRequestable
{
	func request(to url: URL?,
				 type: RequestType,
				 headers: [String: String]?,
				 with data: Data?,
				 cancelsExitingDataTask: Bool,
				 responseHandler: @escaping (Result<Data, NetworkServiceError>) -> Void)
}

protocol JSONDataFetchable
{
	func fetchJSONData<T: Decodable>(url: URL,
									 requestType: RequestType,
									 headers: [String: String]?,
									 cancelsExitingDataTask: Bool,
									 completion: @escaping (Result<T, NetworkServiceError>) -> Void)
}
