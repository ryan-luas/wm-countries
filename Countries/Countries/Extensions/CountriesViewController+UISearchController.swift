//
//  CountriesViewController+UISearchController.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation
import UIKit

// MARK: - UISearchResultsUpdating
extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterCountries(for: searchText)
    }
}

// MARK: - UISearchControllerDelegate
extension CountriesViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.filterCountries(for: "")
    }
}

// MARK: - UISearchBarDelegate
extension CountriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterCountries(for: "")
    }
}
