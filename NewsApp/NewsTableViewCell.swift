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
    private let cellImage = UIImageView()
    
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
        cellTitle.font = UIFont.boldSystemFont(ofSize: 25)
        cellTitle.textColor = .black
        contentView.addSubview(cellTitle)
    }
    
    private func constraintViews(){
        cellTitle.snp.makeConstraints(){
            $0.top.equalToSuperview()
            $0.width.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
        
//        cellDescription.snp.makeConstraints(){
//            $0.top.equalTo(cellTitle.snp.bottom).inset(5)
//
//        }
    }
    
}
