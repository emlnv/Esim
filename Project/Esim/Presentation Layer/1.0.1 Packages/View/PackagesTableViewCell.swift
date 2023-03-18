//
//  CountryTableViewCell.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import UIKit

class PackagesTableViewCell: UITableViewCell {
	
	private typealias C = Constants
	private enum Constants {
		static let title = "Hello"
		static let marginLeading: CGFloat = 20
		static let marginVertical: CGFloat = 10
		static let height: CGFloat = 28
		static let width: CGFloat = 37
	}

	// MARK: - Properties
	
	fileprivate let labelData: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.textColor = .init(named: "esGrey")
		label.font = .italicSystemFont(ofSize: 17)
		return label
	}()
	
	fileprivate let labelValidity: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.textColor = .init(named: "esGrey")
		label.font = .italicSystemFont(ofSize: 17)
		return label
	}()
	
	fileprivate let labelTitle: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.textColor = .init(named: "esGrey")
		label.font = .boldSystemFont(ofSize: 19)
		return label
	}()
	
	fileprivate let labelSubtitle: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.textColor = .init(named: "esGrey")
		label.font = .italicSystemFont(ofSize: 13)
		return label
	}()
	
	fileprivate let button: UIButton = {
		let button = UIButton()
		button.setTitleColor(.init(named: "esGrey"), for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 11)
		return button
	}()
	
	private var image: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	fileprivate var card: UIImageView = {
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
		labelData.text = package.data
		labelValidity.text = package.validity
		labelTitle.text = package.operator?.title
		labelSubtitle.text = package.operator?.countries.first?.title
		button.setTitle("US$" + String(package.price ?? 0) + " - BUY NOW", for: .normal)
		image.image = UIImage(data: package.operator?.imageData ?? Data())
	}

	// MARK: - Private methods
	
	private func configureLayout() {
		[card, labelData, labelValidity, labelTitle, labelSubtitle, image, button].forEach(contentView.addSubview)
		
		card.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			card.centerXAnchor	.constraint(equalTo: contentView.centerXAnchor),
			card.topAnchor		.constraint(equalTo: contentView.topAnchor, constant: 0),
			card.bottomAnchor	.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
			card.heightAnchor	.constraint(equalToConstant: 328)
		])

		labelData.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			labelData.centerYAnchor		.constraint(equalTo: card.centerYAnchor, constant: -C.marginLeading - 5),
			labelData.trailingAnchor	.constraint(equalTo: card.trailingAnchor, constant: -C.marginLeading*2)
		])
		
		labelValidity.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			labelValidity.topAnchor			.constraint(equalTo: labelData.bottomAnchor, constant: C.marginLeading*1.5 + 5),
			labelValidity.trailingAnchor	.constraint(equalTo: labelData.trailingAnchor)
		])
		
		labelTitle.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			labelTitle.topAnchor			.constraint(equalTo: card.topAnchor, constant: C.marginLeading*2),
			labelTitle.leadingAnchor		.constraint(equalTo: card.leadingAnchor, constant: C.marginLeading*2)
		])
		
		labelSubtitle.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			labelSubtitle.topAnchor			.constraint(equalTo: labelTitle.bottomAnchor, constant: C.marginVertical/2),
			labelSubtitle.leadingAnchor		.constraint(equalTo: labelTitle.leadingAnchor)
		])
		
		button.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			button.centerXAnchor		.constraint(equalTo: card.centerXAnchor),
			button.bottomAnchor			.constraint(equalTo: card.bottomAnchor, constant: -C.marginLeading*2 - 8)
		])
		
		image.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			image.topAnchor		.constraint(equalTo: card.topAnchor),
			image.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -C.marginLeading*2),
			image.heightAnchor	.constraint(equalToConstant: 88),
			image.widthAnchor	.constraint(equalToConstant: 140)
		])
	}
}

class PackagesBlueTableViewCell: PackagesTableViewCell {
	
	override func configure(package: Package) {
		super.configure(package: package)
		card.image = Icon.esimBlue
		[labelTitle, labelSubtitle, labelData, labelValidity].forEach { $0.textColor = .white }
		button.setTitleColor(.white, for: .normal)
		labelSubtitle.text = String(package.operator?.countries.count ?? 0) + " Countries"
	}
}

final class PackagesOrangeTableViewCell: PackagesTableViewCell {
	
	override func configure(package: Package) {
		super.configure(package: package)
		card.image = Icon.esimOrange
		[labelTitle, labelSubtitle, labelData, labelValidity].forEach { $0.textColor = .white }
		button.setTitleColor(.white, for: .normal)
		labelSubtitle.text = String(package.operator?.countries.count ?? 0) + " Countries"
	}
}
