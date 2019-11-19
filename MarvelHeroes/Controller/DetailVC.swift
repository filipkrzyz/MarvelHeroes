//
//  DetailVC.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var thumbnailImage: UIImage?
    var character: Character?
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlack
        
        navigationController?.navigationBar.tintColor = .red
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        
        let height = (view.frame.width) * 9 / 12
        
        view.addConstraintWithFormat(format: "H:|[v0]|", views: imageView)
        view.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: nameLabel)
        view.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: descriptionLabel)
        view.addConstraintWithFormat(format: "V:|[v0(\(height))]-16-[v1]-16-[v2]", views: imageView, nameLabel,descriptionLabel)
        
        nameLabel.attributedText = NSAttributedString(string: character?.name ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 35, weight: .semibold)])
        
        descriptionLabel.text = character?.description
        imageView.image = thumbnailImage!
    }
    
    
}
