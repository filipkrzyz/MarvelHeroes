//
//  APIRequest.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation
import UIKit
import CryptoKit


enum SearchError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct APIRequest {
    
    static let public_key = "1e22fad1f056602ee2a8f259b4c9ab5a"
    static let private_key = "40c0a26ccce4824058d6cd03a2f3f23483ef0454"
    let resourceURL: URL
    
    init(keywords: String) {
        let ts = NSDate().timeIntervalSince1970
        let hash = MD5(string: "\(ts)\(APIRequest.private_key)\(APIRequest.public_key)")
        
        let filter: String
        if keywords != "" {
            filter = "nameStartsWith=\(keywords)&"
        } else {
            filter = ""
        }
        
        let resourceString = "https://gateway.marvel.com/v1/public/characters?limit=100&orderBy=-modified&\(filter)ts=\(ts)&apikey=\(APIRequest.public_key)&hash=\(hash)"
        
        let urlResourceString = resourceString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let resourceURL = URL(string: urlResourceString) else { fatalError() }
        
        self.resourceURL = resourceURL
        
        print("hash = \(hash)")
        print("URL = \(resourceURL) ")
    }
    
    
    func getCharacters(completionHandler: @escaping(Result<[Character], SearchError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, _, _) in
            
            guard let jsonData = data else {
                completionHandler(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(Response.self, from: jsonData)
                completionHandler(.success(response.data.results))
                
            } catch {
                completionHandler(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
}

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
