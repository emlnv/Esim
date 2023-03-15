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
	
	private var image: UIImageView = {
		let image = UIImageView()
		return image
	}()
	
	// MARK: - Init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
		configureLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static var reuseIdentifier: String { String(describing: self) }
	
	// MARK: - Public methods
	
	func configure(country: CountryWithImage) {
		label.text = country.title
		image.image = country.image
	}

	// MARK: - Private methods
	
	private func configureLayout() {
		[label, image].forEach(contentView.addSubview)
		
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.centerYAnchor	.constraint(equalTo: contentView.centerYAnchor),
			label.centerXAnchor	.constraint(equalTo: contentView.centerXAnchor),
			label.heightAnchor	.constraint(greaterThanOrEqualToConstant: 65)
		])
		
		image.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			image.leadingAnchor	.constraint(equalTo: contentView.leadingAnchor),
			image.widthAnchor	.constraint(equalToConstant: 37),
			image.topAnchor		.constraint(equalTo: contentView.topAnchor),
			image.heightAnchor	.constraint(greaterThanOrEqualToConstant: 28)
		])
	}
}
