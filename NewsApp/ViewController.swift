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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        buildViews()
    }
    
    private func buildViews(){
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.id)
        view.addSubview(tableView)
        print(articles.count)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints(){
            $0.edges.equalToSuperview()
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
        
        cell.textLabel?.text = articles[indexPath.row].title
        return cell
    }
    
    
}

