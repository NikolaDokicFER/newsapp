//
//  ViewController.swift
//  NewsApp
//
//  Created by Karlo Tomašić on 19.09.2022..
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private var articles = [Article]()
    private var searchBar = SearchBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        NewsApi.shared.getTopNews() { [weak self] result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let result):
                self?.articles = result
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        
        styleViews()
        constraintViews()
    }
    
    private func styleViews(){
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.id)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(searchBar)
    }
    
    private func constraintViews(){
        searchBar.snp.makeConstraints(){
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints(){
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.id, for: indexPath) as! NewsTableViewCell
        
        
        cell.configure(text: articles[indexPath.row].title, description: articles[indexPath.row].description ?? "No description",
                       url: articles[indexPath.row].urlToImage ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

