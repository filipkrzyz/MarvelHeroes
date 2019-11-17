//
//  CustomImageView.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit


let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        
        imageUrlString = urlString
        
        image = UIImage(named: "noimg")
    
        spinner.color = .white
        addSpinner(spinner: spinner)
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            image = imageFromCache
            removeSpinner(spinner: spinner)
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print (error!)
            }
            
            DispatchQueue.main.async {
                
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                    self.removeSpinner(spinner: self.spinner)
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
        }.resume()
    }
}
