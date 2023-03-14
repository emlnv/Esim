//
//  CountryTableViewCell.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import UIKit

final class CountryTableViewCell: UITableViewCell {
	
	// MARK: - Properties
	
	private let label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		return label
	}()
	
	// MARK: - Init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(label)
		separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
		configureLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static var reuseIdentifier: String { String(describing: self) }
	
	// MARK: - Public methods
	
	func configure(country: Country) {
		label.text = country.title
	}
	
	// MARK: - Private methods
	
	private func configureUI() {
		contentView.addSubview(label)
	}
	
	private func configureLayout() {
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.leadingAnchor	.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
			label.topAnchor		.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
			label.bottomAnchor	.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
			label.heightAnchor	.constraint(greaterThanOrEqualToConstant: 65)
		])
	}
}
