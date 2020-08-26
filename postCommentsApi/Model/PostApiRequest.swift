//
//  PostApiRequest.swift
//  postCommentsApi
//
//  Created by Rukhsar on 25/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import Foundation
enum PostError: Error {
    case noDataAvailable
    case canNotProcessData
}
struct PostApiRequest  {
    let postApiUrl = "https://jsonplaceholder.typicode.com/posts"
    func performPostApiRequest(completion : @escaping(Result<[PostApi] , PostError >)-> Void){
        if let url = URL(string: postApiUrl){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([PostApi].self, from: safeData)
                        let postDetails = decodedData
                        completion(.success(postDetails))
                    }catch {
                        completion(.failure(.canNotProcessData))
                    }
                }
            }
            task.resume()
        }
    }
}
