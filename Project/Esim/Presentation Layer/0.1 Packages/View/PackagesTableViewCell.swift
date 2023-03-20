//
//  AreaTableViewCell.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import UIKit

class PackagesTableViewCell: UITableViewCell {
	
	private typealias C = Constants
	private enum Constants {
		static let title = "Hello"
		static let titleButtonStart = "US$"
		static let titleButton = " - BUY NOW"
		static let margin: CGFloat = 20
		static let marginVertical: CGFloat = 30
		static let height: CGFloat = 28
		static let width: CGFloat = 37
		static let imageHeight: CGFloat = 88
		static let imageWidth: CGFloat = 140
		static let aspectRatio: CGFloat = 1.16
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
		image.backgroundColor = .clear
		image.layer.cornerRadius = 12
		return image
	}()
	
	fileprivate var card: UIImageView = {
		let image = UIImageView()
		image.image = Icon.esim?.withRenderingMode(.alwaysTemplate)
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	private var bgView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 7
		view.clipsToBounds = true
		return view
	}()
	
	private var gradientLayer: CAGradientLayer?
	private var colorsGradient: [UIColor] = []

	// MARK: - Init
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard gradientLayer == nil else {
			gradientLayer?.frame.size = frame.size
			return
		}
		gradientLayer = CAGradientLayer()
		gradientLayer?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
		gradientLayer?.locations = [0, 1]
		gradientLayer?.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer?.endPoint = CGPoint(x: 1, y: 0)
		gradientLayer?.colors = colorsGradient.map(\.cgColor)
		bgView.layer.addSublayer(gradientLayer!)
	}
	
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
		let color: UIColor = package.operator?.style == .light ? .systemBackground : .init(named: "esGrey")!
		labelData.text = package.data
		labelValidity.text = package.validity
		labelTitle.text = package.operator?.title
		labelSubtitle.text = package.operator?.countries.first?.title
		button.setTitle(Constants.titleButtonStart + String(package.price ?? 0) + Constants.titleButton, for: .normal)
		image.image = UIImage(data: package.operator?.imageData ?? Data())
		colorsGradient = [UIColor(hex: package.operator?.gradient_start ?? String()) ?? .clear,
						  UIColor(hex: package.operator?.gradient_end ?? String()) ?? .clear]
		card.tintColor = color
		[labelTitle, labelSubtitle, labelData, labelValidity].forEach { $0.textColor = color }
		button.setTitleColor(color, for: .normal)
	}

	// MARK: - Private methods
	
	private func configureLayout() {
		[bgView, card, labelData, labelValidity, labelTitle, labelSubtitle, image, button]
			.forEach(contentView.addSubview)
		
		card.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			card.topAnchor		.constraint(equalTo: contentView.topAnchor, constant: C.margin),
			card.leadingAnchor	.constraint(equalTo: contentView.leadingAnchor, constant: C.margin),
			card.trailingAnchor	.constraint(equalTo: contentView.trailingAnchor, constant: -C.margin),
			card.widthAnchor	.constraint(equalTo: card.heightAnchor, multiplier: C.aspectRatio)
		])

		bgView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			bgView.topAnchor		.constraint(equalTo: contentView.topAnchor, constant: C.margin),
			bgView.leadingAnchor	.constraint(equalTo: contentView.leadingAnchor, constant: C.margin),
			bgView.trailingAnchor	.constraint(equalTo: contentView.trailingAnchor, constant: -C.margin),
			bgView.bottomAnchor		.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -C.margin),
			bgView.widthAnchor		.constraint(equalTo: bgView.heightAnchor, multiplier: C.aspectRatio)
		])

		labelData.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			labelData.centerYAnchor		.constraint(equalTo: card.centerYAnchor, constant: -C.marginVertical),
			labelData.trailingAnchor	.constraint(equalTo: card.trailingAnchor, constant: -C.margin)
		])
		
		labelValidity.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			labelValidity.topAnchor			.constraint(equalTo: labelData.bottomAnchor, constant: C.margin * 2),
			labelValidity.trailingAnchor	.constraint(equalTo: labelData.trailingAnchor)
		])
		
		labelTitle.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			labelTitle.topAnchor			.constraint(equalTo: card.topAnchor, constant: C.margin),
			labelTitle.leadingAnchor		.constraint(equalTo: card.leadingAnchor, constant: C.margin)
		])
		
		labelSubtitle.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			labelSubtitle.topAnchor			.constraint(equalTo: labelTitle.bottomAnchor, constant: 5),
			labelSubtitle.leadingAnchor		.constraint(equalTo: labelTitle.leadingAnchor)
		])
		
		button.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			button.centerXAnchor		.constraint(equalTo: card.centerXAnchor),
			button.bottomAnchor			.constraint(equalTo: card.bottomAnchor, constant: -C.marginVertical)
		])
		
		image.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			image.topAnchor		.constraint(equalTo: contentView.topAnchor),
			image.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -C.margin),
			image.heightAnchor	.constraint(equalToConstant: C.imageHeight),
			image.widthAnchor	.constraint(equalToConstant: C.imageWidth)
		])
	}
}
