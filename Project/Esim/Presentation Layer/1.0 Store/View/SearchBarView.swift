//
//  SearchBarView.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import UIKit

final class SearchBarView: UIView {

	var searchBar = UISearchBar()
	
	// MARK: - Lifecycle
	
	convenience init() {
		self.init(frame: .zero)
		frame = superview?.bounds ?? .zero
		setupUI()
		searchBar.delegate = self
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}
	
	// MARK: - Public Methods
	
	func configure(placeholder: String) {
		searchBar.placeholder = placeholder
	}
	
	// MARK: - Private Methods
	
	private func setupUI() {
		searchBar.backgroundImage = nil //UIImage()
		searchBar.directionalLayoutMargins = .zero
		searchBar.showsCancelButton = false
		searchBar.setImage(Icon.iconSearch, for: .search, state: .normal)
		searchBar.setFont(.systemFont(ofSize: 13))
		searchBar.setSearchIconSize(CGSize(width: 16, height: 16))
		layoutSearchBar()
	}
	
	private func layoutSearchBar() {
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		addSubview(searchBar)
		NSLayoutConstraint.activate([
			searchBar.leadingAnchor	.constraint(equalTo: leadingAnchor),
			searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
			searchBar.topAnchor		.constraint(equalTo: topAnchor),
			searchBar.bottomAnchor	.constraint(equalTo: bottomAnchor)
		])

	}
}

extension SearchBarView:  UISearchBarDelegate {
	
	func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.endEditing(true)
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
		return true
	}
}

private extension UISearchBar {

	enum Constants {
		static let searchField = "searchField"
	}

	func setFont(_ font : UIFont) {
		guard let textfield = value(forKey: Constants.searchField) as? UITextField else { return }
		textfield.font = font
	}

	func setSearchIconSize(_ size : CGSize) {
		guard let textfield = value(forKey: Constants.searchField) as? UITextField else { return }
		textfield.leftView?.frame.size = size
	}
}
