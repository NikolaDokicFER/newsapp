//
//  NewsApi.swift
//  NewsApp
//
//  Created by Nikola Đokić on 19.09.2022..
//

import Foundation

class NewsApi{
    
    static let shared = NewsApi()
    
    let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=669fe9294b26416f9be5bd955b7a764c")
    let allHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=669fe9294b26416f9be5bd955b7a764c")
    
    public func getTopNews(completion: @escaping (Result<[Article], RequestError>) -> Void){
        guard let url = topHeadlinesURL else { return }
        
        let urlTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else{
                completion(.failure(.clientError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...209).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }

            guard let data = data else {
                completion(.failure(.noDataError))
                return
            }

            guard let value = try? JSONDecoder().decode(NewsResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(value.articles))
        }
        urlTask.resume()
    }
    
    public func getAllNews(completion: @escaping (Result<[Article], RequestError>) -> Void){
        guard let url = allHeadlinesURL else { return }
        
        let urlTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else{
                completion(.failure(.clientError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...209).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }

            guard let data = data else {
                completion(.failure(.noDataError))
                return
            }

            guard let value = try? JSONDecoder().decode(NewsResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(value.articles))
        }
        urlTask.resume()
    }
}
