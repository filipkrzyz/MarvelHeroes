//
//  CharacterCell.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var character: Character? {
        didSet {
            nameLabel.text = character?.name
            setupThumbnailImage()
        }
    }
    
    
    func setupThumbnailImage() {
        
        if let path = character?.thumbnail.path {
            if let ext = character?.thumbnail.ext {
                
                let thumbnailImageURL = "https\(path.dropFirst(4)).\(ext)"
                
                self.thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageURL)
            }
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "noimg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = ""
        return label
    }()
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(nameLabel)
        
        
        addConstraintWithFormat(format: "H:|[v0]|", views: thumbnailImageView)
        
        addConstraintWithFormat(format: "H:|-8-[v0]-8-|", views: nameLabel)
        
        addConstraintWithFormat(format: "V:|[v0]-8-[v1(44)]|", views: thumbnailImageView, nameLabel)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

