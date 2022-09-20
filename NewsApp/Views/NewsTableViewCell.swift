//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Nikola Đokić on 19.09.2022..
//

import Foundation
import UIKit
import SnapKit

class NewsTableViewCell: UITableViewCell {
	static let id = "newsCell"
	private let cellTitle = UILabel()
	private let cellDescription = UILabel()
	private var cellImage = UIImageView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.contentView.isUserInteractionEnabled = true
		styleViews()
		constraintViews()
	}

	required init?(coder: NSCoder) {
		fatalError("Init(coder:) has not been implemented")
	}

	private func styleViews() {
		cellTitle.font = UIFont.boldSystemFont(ofSize: 18)
		cellTitle.textColor = .black
		cellTitle.numberOfLines = 0
		contentView.addSubview(cellTitle)

		cellDescription.font = UIFont.boldSystemFont(ofSize: 16)
		cellDescription.textColor = .darkGray
		cellDescription.numberOfLines = 0
		contentView.addSubview(cellDescription)

		cellImage.layer.cornerRadius = 5
		cellImage.layer.masksToBounds = true
		contentView.addSubview(cellImage)
	}

	private func constraintViews() {
		cellTitle.snp.makeConstraints {
			$0.top.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(10)
			$0.height.equalTo(60)
		}

		cellDescription.snp.makeConstraints {
			$0.top.equalTo(cellTitle.snp.bottom)
			$0.leading.equalToSuperview().inset(20)
			$0.trailing.equalToSuperview().inset(160)
			$0.bottom.lessThanOrEqualToSuperview()
		}

		cellImage.snp.makeConstraints {
			$0.top.equalTo(cellTitle.snp.bottom)
			$0.leading.equalTo(cellDescription.snp.trailing)
			$0.trailing.equalToSuperview().inset(10)
			$0.bottom.equalToSuperview().inset(10)
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cellImage.image = nil
		cellTitle.text = nil
		cellDescription.text = nil
	}

	public func configure(with article: ArticleViewModel) {
		cellTitle.text = article.title
		cellDescription.text = article.description

		if let data = article.imageData {
			cellImage.image = UIImage(data: data)
		} else if let url = article.urlToImage {
			URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
				guard let data = data, error == nil else {
				return
				}
				article.imageData = data

				DispatchQueue.main.async {
					self?.cellImage.image = UIImage(data: data)
				}
			}
			.resume()
		}
	}
}
