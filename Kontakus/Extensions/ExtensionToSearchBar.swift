//
//  ExtensionToSearchBar.swift
//  Kontakus
//
//  Created by Cüneyd on 13.01.2020.
//  Copyright © 2020 com.kontakus.www. All rights reserved.
//

import UIKit

extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating {
    //MARK:- Initial setup of search bar
    func searchBarSetup() {
        searchController.searchBar.scopeButtonTitles = ["📞 Call", "WhatsApp", "Facetime", "Email"]
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationController!.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.kontakBlue]
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.autocapitalizationType = .words
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissTheKeyboard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        for ob: UIView in ((searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.kontakBlue, for: .normal)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let dataFiltered = searchText.isEmpty ? nameArray : nameArray.filter({ (dat) -> Bool in dat.range(of: searchText, options: .caseInsensitive) != nil })
        dropButton.dataSource = dataFiltered
        dropButton.show()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissTheKeyboard()
        searchBar.text = ""
        dropButton.hide()
    }
}
