//
//  ArticleViewModel.swift
//  NewsApp
//
//  Created by Nikola Đokić on 20.09.2022..
//

import Foundation

class ArticleViewModel {
	let title: String
	let description: String
	let url: URL?
	let urlToImage: URL?
	var imageData: Data?
	let datePosted: Date

	init(
		title: String,
		description: String,
		url: URL?,
		urlToImage: URL?,
		datePosted: String
	) {
		self.title = title
		self.description = description
		self.url = url
		self.urlToImage = urlToImage
		self.imageData = nil

		let dateFormatter = ISO8601DateFormatter()
		self.datePosted = dateFormatter.date(from: datePosted) ?? Date(timeIntervalSince1970: 5000000)
	}
}
