//
//  CountriesViewController.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation
import UIKit

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCountries
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CountryTableViewCell

        if let country = viewModel.country(at: indexPath.row) {
            cell.configure(with: country)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = viewModel.country(at: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
