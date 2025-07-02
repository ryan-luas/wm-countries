//
//  Constants.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation

struct Constants {
    // labels and cells ¬
    static let rootNavTitleLabel = "Countries".localizedCapitalized
    static let preSearchDefaultPlaceholderLabel = "Search by country name or capital"
    static let countryCellIdentifier = "CountryCell"
    static let pullToRefreshLabel = "Pull to refresh countries".localizedCapitalized

    // Networking/URLs etc. ¬
    static let countriesEndpoint = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"

    // Alerts ¬
    static let alertControllerTitle = "Error".localizedCapitalized
    static let retryActionTitle = "Retry".localizedCapitalized
    static let okActionLabel = "OK".localizedUppercase

    // Errors ¬
    static let invalidUrlConfigError = "Invalid URL configuration".localizedCapitalized
    static let noDataReceivedError = "No data received from server".localizedCapitalized
    static let countryListEmptyError = "The country list is empty".localizedCapitalized
    static let invalidServerResponseError = "Invalid server response".localizedCapitalized
    static let serverError = "Server error ".localizedCapitalized
    static let serverErrorAddlContext = " Please try again later.".localizedCapitalized
    static let requestFailedCheckConnectionError = "No internet connection. Please check your network and try again.".localizedCapitalized
    static let requestTimedOutError = "Request timed out. Please try again.".localizedCapitalized
    static let networkError = "Network error: ".localizedCapitalized
    static let failedToParseError = "Failed to parse country data: ".localizedCapitalized
}
