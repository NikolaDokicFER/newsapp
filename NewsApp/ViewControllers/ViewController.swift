//
//  ViewController.swift
//  NewsApp
//
//  Created by Karlo Tomašić on 19.09.2022..
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private var articles = [Article]()
    private var filteredArticles = [Article]()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        NewsApi.shared.getTopNews() { [weak self] result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let result):
                self?.articles = result
                self?.filteredArticles = result
                
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
        
    }
    
    private func constraintViews(){
        tableView.snp.makeConstraints(){
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = URL(string: filteredArticles[indexPath.row].url) else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.id, for: indexPath) as! NewsTableViewCell
        
        
        cell.configure(text: filteredArticles[indexPath.row].title, description: filteredArticles[indexPath.row].description ?? "No description",
                       url: filteredArticles[indexPath.row].urlToImage ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredArticles = articles.filter{
                $0.title.range(of: searchText, options: .caseInsensitive) != nil }
        } else {
            filteredArticles = articles
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredArticles = articles
        self.tableView.reloadData()
    }
}

