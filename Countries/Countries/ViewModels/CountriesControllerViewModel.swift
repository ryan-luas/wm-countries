//
//  CountriesControllerViewModel.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation
import UIKit
class CountriesControllerViewModel {
    weak var delegate: CountriesControllerViewModelDelegate?

    var countries: [Country] = []
    var filteredCountries: [Country] = []
    var isLoadingData = false
    var dataTask: URLSessionDataTask?

    // MARK: - Computed Properties
    var numberOfCountries: Int {
        return filteredCountries.count
    }
 
    var isSearching: Bool = false {
        didSet {
            if !isSearching {
                filteredCountries = countries
            }
        }
    }

    func loadCountries() {
        guard !isLoadingData else { return }

        isLoadingData = true
        delegate?.viewModelDidStartLoading()
        
        guard let url = URL(string: Constants.countriesEndpoint) else {
            handleLoadingError(NetworkError.invalidURL)
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30.0
        request.cachePolicy = .reloadIgnoringLocalCacheData

        dataTask?.cancel() // Cancel any existing request

        dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            guard let data = data, !data.isEmpty else {
                self?.handleLoadingError(NetworkError.noData)
                return
            }

            DispatchQueue.main.async {
                self?.isLoadingData = false
                self?.delegate?.viewModelDidFinishLoading()

                if let error = error {
                    if (error as NSError).code == NSURLErrorCancelled {
                        return // Request was cancelled, don't show error
                    }
                    self?.handleLoadingError(NetworkError.requestFailed(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.handleLoadingError(NetworkError.invalidResponse)
                    return
                }

                guard 200...299 ~= httpResponse.statusCode else {
                    self?.handleLoadingError(NetworkError.serverError(httpResponse.statusCode))
                    return
                }

                self?.parseCountriesData(data)
            }
        }

        dataTask?.resume()
    }

    func filterCountries(for searchText: String) {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        isSearching = !trimmedSearchText.isEmpty

        if trimmedSearchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { country in
                country.name.localizedCaseInsensitiveContains(trimmedSearchText) ||
                country.capital.localizedCaseInsensitiveContains(trimmedSearchText)
            }
        }

        DispatchQueue.main.async {
            self.delegate?.viewModelDidUpdateCountries()
        }
    }

    func country(at index: Int) -> Country? {
        guard index >= 0 && index < filteredCountries.count else { return nil }
        return filteredCountries[index]
    }

    func cancelDataTask() {
        dataTask?.cancel()
    }

    private func parseCountriesData(_ data: Data) {
        do {
            let countries = try JSONDecoder().decode([Country].self, from: data)
            
            if countries.isEmpty {
                handleLoadingError(NetworkError.emptyData)
                return
            }
            
            self.countries = countries
            self.filteredCountries = countries
            
            delegate?.viewModelDidUpdateCountries()
            
        } catch {
            handleLoadingError(NetworkError.parsingFailed(error))
        }
    }

    private func handleLoadingError(_ error: NetworkError) {
        delegate?.viewModelDidEncounterError(error)
    }
}
