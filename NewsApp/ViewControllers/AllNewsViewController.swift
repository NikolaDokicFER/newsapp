//
//  AllNewsViewController.swift
//  NewsApp
//
//  Created by Karlo Tomašić on 20.09.2022..
//

import Foundation
import UIKit

class AllNewsViewController: UIViewController{
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.searchController = searchController
    }
}
