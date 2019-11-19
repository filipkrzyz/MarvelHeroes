//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import Combine

class ViewController: UICollectionViewController {

    // MARK: Properties
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
    
    let noResultsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.attributedText = NSAttributedString(string: "Sorry, no characters were found. \n Try different search", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .light)])
        return label
    }()
    
    var listOfCharacters = [Character] ()
    
    var totalCharacters = 0 // total number of resources available given the current filter set
    
    var offset = 0 // requested offset (number of skipped results) of the call
    
    var selectedCharacter: (character: Character, thumbnail: UIImage)?
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    let cellId = "CharacterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        addSearchBar()
        setupSearchBarListeners()
        searchBar.delegate = self
        
        collectionView.backgroundColor = .darkBlack
        
        // register cell
        collectionView!.register(CharacterCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchCharacters(keywords: "", offset: offset)
        addNoResultLabel()
        
    }
    
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkBlack
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
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
    
    func addNoResultLabel() {
        view.addSubview(noResultsLabel)
        noResultsLabel.isHidden = true
        noResultsLabel.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: noResultsLabel)
        noResultsLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func addSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.addConstraintWithFormat(format: "H:|[v0]|", views: searchBar)
        searchBar.addConstraintWithFormat(format: "V:|[v0(50)]", views: searchBar)
        
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
    }
    
    private func setupSearchBarListeners() {
         let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
         publisher
             .map {
                 ($0.object as! UISearchTextField).text
         }
         .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
         .removeDuplicates()
         .sink(receiveValue: { (searchBarText) in
            self.offset = 0
            self.fetchCharacters(keywords: searchBarText ?? "", offset: self.offset)
         })
     }
    
    
    func fetchCharacters(keywords: String, offset: Int) {
        view.addSpinner(spinner: spinner)
        
        let apiRequest = APIRequest(keywords: keywords, offset: offset)
        
        apiRequest.getCharacters() { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let results, let total):
                if offset == 0 {
                    self.listOfCharacters = results
                } else {
                    self.listOfCharacters.append(contentsOf: results)
                }
                
                self.totalCharacters = total
                DispatchQueue.main.async {
                    if self.listOfCharacters.count == 0 {
                        self.noResultsLabel.isHidden = false
                    } else { self.noResultsLabel.isHidden = true }
                    
                    self.collectionView?.reloadData()
                    self.view.removeSpinner(spinner: self.spinner)
                }
            }
        }
    }

}



extension ViewController: UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        offset = 0
        fetchCharacters(keywords: searchBarText, offset: offset)
        searchBar.resignFirstResponder()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfCharacters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CharacterCell
        
        cell.backgroundColor = .black //.darkBlack
        
        cell.character = self.listOfCharacters[indexPath.row]
        
        if indexPath.row == self.listOfCharacters.count - 1 {
            if totalCharacters > self.listOfCharacters.count {
                offset = offset + 100
                fetchCharacters(keywords: self.searchBar.text ?? "", offset: offset)
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.collectionView.frame.size.width - (3*16))/2, height: self.collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 50, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CharacterCell
        let characterThumbnail = cell.thumbnailImageView.image
        selectedCharacter = (character: cell.character!, thumbnail: characterThumbnail!)
      
        let detailVC = DetailVC()
        detailVC.character = selectedCharacter?.character
        detailVC.thumbnailImage = (selectedCharacter?.thumbnail)!
        
        navigationController?.pushViewController(detailVC, animated: true)
        
        searchBar.resignFirstResponder()
    }
    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let darkBlack = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
}

