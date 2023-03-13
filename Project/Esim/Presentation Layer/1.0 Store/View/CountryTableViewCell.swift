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
	
	override var reuseIdentifier: String? { Self.description() }
	
	// MARK: - Public methods
	
	func configure(title: String?) {
		label.text = title
	}
	
	// MARK: - Private methods
	
	private func configureUI() {
		contentView.addSubview(label)
	}
	
	private func configureLayout() {
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		])
	}
}
