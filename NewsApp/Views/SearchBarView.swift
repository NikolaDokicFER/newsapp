//
//  SearchBarView.swift
//  NewsApp
//
//  Created by Karlo Tomašić on 19.09.2022..
//

import Foundation
import UIKit
import SnapKit

class SearchBarView: UIView{
    private let magnifierImage = UIImageView()
    private let inputField = UITextField()
    private let deleteButton = UIButton()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        styleViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    private func styleViews(){
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.layer.cornerRadius = 10
        
        magnifierImage.tintColor = .black
        magnifierImage.image = UIImage(systemName: "magnifyingglass")
        self.addSubview(magnifierImage)
        
        inputField.textColor = .black
        inputField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.addSubview(inputField)
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .black
        deleteButton.addTarget(self, action: #selector(clearInput), for: .touchUpInside)
        self.addSubview(deleteButton)
    }
    
    private func constraintViews(){
        magnifierImage.snp.makeConstraints(){
            $0.leading.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(25)
        }
        
        inputField.snp.makeConstraints(){
            $0.leading.equalTo(magnifierImage.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
        
        deleteButton.snp.makeConstraints(){
            $0.leading.equalTo(inputField.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
    }
    
    @objc func clearInput(){
        inputField.text = ""
        inputField.resignFirstResponder()
    }
}
