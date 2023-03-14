//
//  EsimTarget.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

enum EsimTarget: ESTargetType {
	case getPopularCoutries
	case getFlag(URL)
	
	var baseURL: URL {
		switch self {
			case .getPopularCoutries:
				return URL(string: "https://www.airalo.com")! // swiftlint:disable:this force_unwrapping
			case .getFlag(let url): return url
		}
	}
	
	var path: String {
		switch self {
			case .getPopularCoutries:
				return "/api/v2/countries"
			case .getFlag:
				return String()
		}
	}
	
	var method: ESMethod {
		switch self {
			case .getPopularCoutries, .getFlag:
				return .get
		}
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: ESTask {
		switch self {
			case .getPopularCoutries:
				let parameters: [String: Any] = [
					"type": "popular"
				]
				return .requestParameters(parameters: parameters, encoding: ESURLEncoding.default)
			case .getFlag:
				return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		switch self {
			case .getPopularCoutries:
				return [
					"Content-Type": "application/json",
					"Accept-Language": "us-US;q=1.0"
				]
			case .getFlag: return nil
		}
	}
	
}