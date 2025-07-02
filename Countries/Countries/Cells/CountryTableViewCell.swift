//
//  CountryTableViewCell.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation
import UIKit

class CountryTableViewCell: UITableViewCell {
    private var viewModel: CountryCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .default
        isAccessibilityElement = true
        accessibilityTraits = .button
    }

    // MARK: - Configuration
    func configure(with country: Country) {
        viewModel?.containerStackView.removeFromSuperview()
        viewModel = CountryCellViewModel(country: country)
        viewModel?.setupConstraints(in: contentView)

        // Update accessibility from view model
        accessibilityLabel = viewModel?.containerStackView.accessibilityLabel
        accessibilityHint = viewModel?.containerStackView.accessibilityHint
    }

// MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.containerStackView.removeFromSuperview()
        viewModel = nil
    }

    var currentViewModel: CountryCellViewModel? {
        return viewModel
    }
}
