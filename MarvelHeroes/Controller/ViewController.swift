//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import Combine

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
    
    let noResultsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.attributedText = NSAttributedString(string: "Sorry, no characters were found. \n Try different search", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .light)])
        return label
    }()
    
    var listOfCharacters = [Character] ()
    
    var selectedCharacter: (character: Character, thumbnail: UIImage)?
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup navigation bar
        navigationController?.navigationBar.barTintColor = .darkBlack
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
        addNavBarImage()
        
        collectionView.backgroundColor = .darkBlack
        
        searchBar.delegate = self
        
        // register cell
        collectionView!.register(CharacterCell.self, forCellWithReuseIdentifier: "CharacterCell")
        
        spinner.color = .white
        fetchCharacters(keywords: "")
        addNoResultLabel()
        setupSearchBarListeners()
        addSearchBar()
        collectionView.isUserInteractionEnabled = true
    
    }
    
    private func setupSearchBarListeners() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
        publisher
            .map {
                ($0.object as! UISearchTextField).text
        }
        .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink(receiveValue: { (str) in
            self.fetchCharacters(keywords: str ?? "")
        })
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        fetchCharacters(keywords: searchBarText)
        searchBar.resignFirstResponder()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
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

extension ViewController {
    
    
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

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfCharacters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        
        cell.backgroundColor = .black //.darkBlack
        
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

