//
//  NetworkError.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case noData
    case emptyData
    case invalidResponse
    case serverError(Int)
    case requestFailed(Error)
    case parsingFailed(Error)
}
