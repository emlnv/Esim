//
//  CountryTableViewCell.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import UIKit

final class PackagesTableViewCell: UITableViewCell {
	
	private typealias C = Constants
	private enum Constants {
		static let title = "Hello"
		static let marginLeading: CGFloat = 20
		static let marginVertical: CGFloat = 10
		static let height: CGFloat = 28
		static let width: CGFloat = 37
	}

	// MARK: - Properties
	
	private let label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 15)
		return label
	}()
	
	private var image: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	private var card: UIImageView = {
		let image = UIImageView()
		image.image = Icon.esim
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	private var bgView: ShadowView = {
		let view = ShadowView()
		view.clipsToBounds = false
		view.layer.cornerRadius = 7
		return view
	}()
	
	// MARK: - Init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
		configureLayout()
		backgroundColor = .clear
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static var reuseIdentifier: String { String(describing: self) }
	
	// MARK: - Public methods
	
	func configure(package: Package) {
		label.text = package.title
		image.image = UIImage(data: package.operator?.imageData ?? Data())
	}

	// MARK: - Private methods
	
	private func configureLayout() {
		[card, label, image].forEach(contentView.addSubview)
		
		card.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			card.centerXAnchor	.constraint(equalTo: contentView.centerXAnchor),
			card.topAnchor		.constraint(equalTo: contentView.topAnchor, constant: 0),
			card.bottomAnchor	.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
			card.widthAnchor	.constraint(equalToConstant: 375)
		])

		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.centerYAnchor		.constraint(equalTo: card.centerYAnchor, constant: -8),
			label.trailingAnchor	.constraint(equalTo: card.trailingAnchor, constant: C.marginLeading/2)
		])
		
		image.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			image.topAnchor	.constraint(equalTo: card.topAnchor, constant: C.marginVertical*2),
			image.trailingAnchor	.constraint(equalTo: card.trailingAnchor, constant: -C.marginLeading*2),
			image.heightAnchor	.constraint(equalToConstant: 90),
			image.widthAnchor	.constraint(equalToConstant: 142)
		])
	}
}
