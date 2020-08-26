//
//  commentApiRequest.swift
//  postCommentsApi
//
//  Created by Rukhsar on 25/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import Foundation
import Foundation
enum CommentError: Error {
    case noDataAvailable
    case canNotProcessData
}
struct CommetnApiRequest  {
    let postApiUrl = "https://jsonplaceholder.typicode.com/posts/1/comments"
    func performCommentsApiRequest(completion : @escaping(Result<[CommentApi] , CommentError >)-> Void){
        if let url = URL(string: postApiUrl){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([CommentApi].self, from: safeData)
                        let commentDetails = decodedData
                        completion(.success(commentDetails))
                        // print(commentDetails)
                    }catch {
                        completion(.failure(.canNotProcessData))
                    }
                }
            }
            task.resume()
        }
    }
}
