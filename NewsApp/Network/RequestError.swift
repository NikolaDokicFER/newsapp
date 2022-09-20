//
//  RequestError.swift
//  NewsApp
//
//  Created by Nikola Đokić on 19.09.2022..
//

import Foundation

enum RequestError: Error {
	case clientError
	case serverError
	case noDataError
	case decodingError
}
