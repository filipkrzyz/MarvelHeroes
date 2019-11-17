//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UISearchBarDelegate {

   
    private let headerIdentifier = "headerCellId"

    let searchBar: UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search character..."
        s.sizeToFit()
        s.isTranslucent = true
        s.barTintColor = .darkBlack
        s.backgroundColor = .darkBlack
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    var listOfCharacters = [Character] ()
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup navigation bar
        navigationController?.navigationBar.barTintColor = .darkBlack
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
        addNavBarImage()
        
        collectionView.backgroundColor = .darkBlack
        
        // register header
        collectionView!.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        // pin search bar to the top
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        searchBar.delegate = self
        
        // register cell
        collectionView!.register(CharacterCell.self, forCellWithReuseIdentifier: "CharacterCell")
        
        spinner.color = .white
        fetchCharacters(keywords: "")
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        fetchCharacters(keywords: searchBarText)
    }
    
    func fetchCharacters(keywords: String) {
        view.addSpinner(spinner: spinner)
        let apiRequest = APIRequest(keywords: keywords)
        apiRequest.getCharacters() { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let results):
                self.listOfCharacters = results
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.view.removeSpinner(spinner: self.spinner)
                }
                //print("data.result = \(results[0].name)")
            }
        }
    }

}

extension ViewController {
    
    // adding search bar header to the collection view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
        
        header.addSubview(searchBar)
        
        searchBar.addConstraintWithFormat(format: "H:|[v0]|", views: searchBar)
        searchBar.addConstraintWithFormat(format: "V:|[v0]|", views: searchBar)
        
        // setting colors of the search bar
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.lightGray
            textfield.textColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfCharacters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        
        cell.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        
        cell.character = self.listOfCharacters[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.collectionView.frame.size.width - (3*16))/2, height: self.collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let darkBlack = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
}

