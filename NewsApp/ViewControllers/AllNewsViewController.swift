//
//  AllNewsViewController.swift
//  NewsApp
//
//  Created by Nikola Đokić on 20.09.2022..
//


import UIKit
import SafariServices

class AllNewsViewController: UIViewController{
    
    private let tableView = UITableView()
    private var articles = [ArticleViewModel]()
    private var filteredArticles = [ArticleViewModel]()
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControll = UIRefreshControl()
    private let latestButtoon = UIButton()
    private let oldestButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControll.addTarget(self, action: #selector (refresh), for: .valueChanged)
        
        fetchNews()
        styleViews()
        constraintViews()
    }
    
    private func fetchNews(){
        NewsApi.shared.getNews(url: NewsApi.topHeadlinesURL) { [weak self] result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let result):
                self?.articles = result.compactMap({
                    ArticleViewModel(title: $0.title, description: $0.description ?? "No Description", url: URL(string: $0.url), urlToImage: URL(string: $0.urlToImage ?? ""), datePosted: String($0.publishedAt.prefix(19) + "Z"))
                })
                
                self?.filteredArticles = self?.articles ?? []
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControll.endRefreshing()
                }
            }
        }
    }
    
    private func styleViews(){
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.id)
        tableView.addSubview(refreshControll)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        latestButtoon.setTitle("latest", for: .normal)
        latestButtoon.layer.cornerRadius = 10
        latestButtoon.backgroundColor = .white
        latestButtoon.setTitleColor(.black, for: .normal)
        latestButtoon.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        latestButtoon.layer.borderWidth = 2
        latestButtoon.addTarget(self, action: #selector(sortLatest), for: .touchUpInside)
        view.addSubview(latestButtoon)
        
        oldestButton.setTitle("oldest", for: .normal)
        oldestButton.layer.cornerRadius = 10
        oldestButton.backgroundColor = .black
        oldestButton.setTitleColor(.white, for: .normal)
        oldestButton.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        oldestButton.layer.borderWidth = 2
        oldestButton.addTarget(self, action: #selector(sortOldest), for: .touchUpInside)
        view.addSubview(oldestButton)
    }
    
    private func constraintViews(){
        latestButtoon.snp.makeConstraints(){
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(85)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        
        oldestButton.snp.makeConstraints(){
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(85)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints(){
            $0.top.equalTo(latestButtoon.snp.bottom).offset(10)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    @objc func refresh(){
        fetchNews()
        sortLatest()
    }
    
    @objc func sortLatest(){
        latestButtoon.backgroundColor = .white
        latestButtoon.setTitleColor(.black, for: .normal)
        
        oldestButton.backgroundColor = .black
        oldestButton.setTitleColor(.white, for: .normal)
        
        filteredArticles = filteredArticles.sorted(by: {$0.datePosted > $1.datePosted})
        self.tableView.reloadData()
    }
    
    @objc func sortOldest(){
        oldestButton.backgroundColor = .white
        oldestButton.setTitleColor(.black, for: .normal)
        
        latestButtoon.backgroundColor = .black
        latestButtoon.setTitleColor(.white, for: .normal)
        
        filteredArticles = filteredArticles.sorted(by: {$0.datePosted < $1.datePosted})
        self.tableView.reloadData()
    }
}

extension AllNewsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = filteredArticles[indexPath.row].url else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

extension AllNewsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.id, for: indexPath) as! NewsTableViewCell
        
        
        cell.configure(with: filteredArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension AllNewsViewController: UISearchBarDelegate{
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
