//
//  CountryCellViewModel.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import Foundation
import UIKit

class CountryCellViewModel {
    private let country: Country

// MARK: - UI Elements
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemGray2
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let topRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(country: Country) {
        self.country = country
        setupLabels()
        setupStackViews()
        setupAccessibility()
        observeContentSizeChanges()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup Methods
    private func setupLabels() {
        nameLabel.text = displayName
        codeLabel.text = codeText
        
        // Set content hugging and compression resistance
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    private func setupStackViews() {
        topRowStackView.addArrangedSubview(nameLabel)
        topRowStackView.addArrangedSubview(codeLabel)
        containerStackView.addArrangedSubview(topRowStackView)
    }

    private func setupAccessibility() {
        containerStackView.isAccessibilityElement = true
        containerStackView.accessibilityTraits = .button
        containerStackView.accessibilityLabel = accessibilityLabel
        containerStackView.accessibilityHint = accessibilityHint
    }

    private func observeContentSizeChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    @objc private func contentSizeCategoryDidChange() {
        // Update fonts for Dynamic Type
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        codeLabel.font = UIFont.preferredFont(forTextStyle: .callout)

        // Adjust stack view spacing for larger text sizes
        let isAccessibilitySize = UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory
        containerStackView.spacing = isAccessibilitySize ? 8 : 4
        topRowStackView.spacing = isAccessibilitySize ? 12 : 8
    }

    private var nameText: String {
        return country.name
    }

    private var regionText: String {
        return country.region ?? "N/A"
    }

    private var displayName: String {
        return "\(nameText), \(regionText)"
    }

    private var codeText: String? {
        guard let code = country.code else { return nil }
        return "\(code) | \(country.capital)"
    }

// MARK: - Accessibility Properties
    private var accessibilityLabel: String {
        let code = country.code ?? "N/A"
        return "\(nameText), \(regionText), Capital: \(country.capital), Code: \(code)"
    }
    
    private var accessibilityHint: String {
        return "Double tap to select this country"
    }

    // MARK: - Data Access
    var underlyingCountry: Country {
        return country
    }

    // MARK: - Constraints Setup
    func setupConstraints(in contentView: UIView) {
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Minimum width for code label on larger devices
            codeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}
