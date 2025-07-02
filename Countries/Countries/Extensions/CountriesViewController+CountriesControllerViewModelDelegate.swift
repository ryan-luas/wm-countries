//
//  CountriesViewController+CountriesControllerViewModelDelegate.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation
import UIKit

extension CountriesViewController: CountriesControllerViewModelDelegate {
    func viewModelDidUpdateCountries() {
        showSuccessState()
        tableView.reloadData()
    }

    func viewModelDidStartLoading() {
        showLoadingState()
    }

    func viewModelDidFinishLoading() {
        hideLoadingState()
    }

    func viewModelDidEncounterError(_ error: NetworkError) {
        handleLoadingError(error)
    }
}
