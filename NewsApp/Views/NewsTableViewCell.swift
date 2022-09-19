//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Karlo Tomašić on 19.09.2022..
//

import Foundation
import UIKit
import SnapKit

class NewsTableViewCell: UITableViewCell{
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
    
    private func styleViews(){
        cellTitle.font = UIFont.boldSystemFont(ofSize: 18)
        cellTitle.textColor = .black
        cellTitle.numberOfLines = 0
        contentView.addSubview(cellTitle)
        
        cellDescription.font = UIFont.boldSystemFont(ofSize: 16)
        cellDescription.textColor = .darkGray
        cellDescription.numberOfLines = 0
    
        contentView.addSubview(cellDescription)
    
        contentView.addSubview(cellImage)
    }
    
    private func constraintViews(){
        cellTitle.snp.makeConstraints(){
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(60)
        }
        
        cellDescription.snp.makeConstraints(){
            $0.top.equalTo(cellTitle.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(160)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        cellImage.snp.makeConstraints(){
            $0.top.equalTo(cellTitle.snp.bottom)
            $0.leading.equalTo(cellDescription.snp.trailing)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    public func configure(text: String, description: String, url: String){
        cellTitle.text = text
        cellDescription.text = description
        
        guard let imageUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                self?.cellImage.image = UIImage(data: data)
            }
        }.resume()
    }
    
}
