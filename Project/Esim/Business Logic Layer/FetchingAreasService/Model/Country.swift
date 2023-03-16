//
//  Country.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

struct CountryWithImage: Equatable {
	init(country: Country, image: ESImage) {
		self.id = country.id
		self.slug = country.slug
		self.title = country.title
		self.image = image
	}
	
	var id: Int
	var slug: String
	var title: String
	var image: ESImage
}

struct Country: Decodable, Equatable {
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
	var packages: [Package]?
}

struct Flag: Decodable, Equatable {
	let width: Int
	let height: Int
	let url: String
}
