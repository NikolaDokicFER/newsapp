//
//  Article.swift
//  NewsApp
//
//  Created by Nikola Đokić on 19.09.2022..
//

import Foundation

struct Article: Codable {
	let title: String
	let description: String?
	let url: String
	let urlToImage: String?
	let publishedAt: String
}
