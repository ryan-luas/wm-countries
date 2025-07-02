//
//  CountriesControllerViewModelDelegate.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation
protocol CountriesControllerViewModelDelegate: AnyObject {
    func viewModelDidUpdateCountries()
    func viewModelDidStartLoading()
    func viewModelDidFinishLoading()
    func viewModelDidEncounterError(_ error: NetworkError)
}
