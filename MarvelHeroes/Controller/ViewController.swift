//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        addNavBarImage()
    }

    
    func addNavBarImage() {
        
        let navController = navigationController!
        
        let image = UIImage(named: "marvel_logo.png")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image!.size.width / 2
        let bannerY = bannerHeight / 2 - image!.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
    }

}

