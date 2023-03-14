//
//  Country.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

struct Country: Decodable, Equatable {
	var id: Int
	var slug: String
	var title: String
	var image: Flag
}

struct Flag: Decodable, Equatable {
	let width: Int
	let height: Int
	let url: String
}
