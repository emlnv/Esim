//
//  Country.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation.NSData

struct Country: Decodable, Equatable, Hashable {
	init() {
		self.init(id: Int(), slug: String(), title: String(), image: Flag(width: Int(), height: Int(), url: String()))
	}
	
	init(id: Int, slug: String, title: String, image: Flag) {
		self.id = id
		self.slug = slug
		self.title = title
		self.image = image
	}
	
	var id: Int
	var slug: String
	var title: String
	var image: Flag
	var imageData: Data?
	var packages: [Package]?
	var package_count: Int?
}

struct Flag: Decodable, Equatable, Hashable {
	let width: Int
	let height: Int
	let url: String
}
