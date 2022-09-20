//
//  NewsApi.swift
//  NewsApp
//
//  Created by Nikola Đokić on 19.09.2022..
//

import Foundation

class NewsApi {
	static let shared = NewsApi()

	static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&pageSize=X&page=1&apiKey=669fe9294b26416f9be5bd955b7a764c")

	public func getNews(url: URL?, completion: @escaping (Result<[Article], RequestError>) -> Void) {
		guard let url = url else { return }

		let urlTask = URLSession.shared.dataTask(with: url) { data, response, error in
			guard error == nil else {
				completion(.failure(.clientError))
				return
			}
			guard let response = response as? HTTPURLResponse,
				(200...209).contains(response.statusCode) else {
					completion(.failure(.serverError))
					return
			}
			guard let data = data else {
				completion(.failure(.noDataError))
				return
			}
			guard let value = try? JSONDecoder().decode(NewsResponse.self, from: data) else {
				completion(.failure(.decodingError))
				return
			}
			completion(.success(value.articles))
		}
		urlTask.resume()
	}
}
