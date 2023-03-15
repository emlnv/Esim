//
//  CountryTableViewCell.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import UIKit

final class CountryTableViewCell: UITableViewCell {
	
	private typealias C = Constants
	private enum Constants {
		static let title = "Hello"
		static let marginLeading: CGFloat = 28
		static let height: CGFloat = 28
		static let width: CGFloat = 37
	}

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
			label.leadingAnchor	.constraint(equalTo: image.trailingAnchor, constant: C.marginLeading)
		])
		
		image.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			image.centerYAnchor	.constraint(equalTo: contentView.centerYAnchor),
			image.leadingAnchor	.constraint(equalTo: contentView.leadingAnchor, constant: C.marginLeading),
			image.heightAnchor	.constraint(equalToConstant: C.height),
			image.widthAnchor	.constraint(equalToConstant: C.width)
		])
	}
}
