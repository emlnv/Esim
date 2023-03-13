//
//  FactoryBridge.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Factory

final class ESContainer {
	private init() {}
	static var shared = ESContainer()
	private static var container = Container.shared
}

extension ESContainer: ManagedContainer {
	var manager: ContainerManager {
		get {
			Self.container.manager
		}
		set {
			Self.container.manager = newValue
		}
	}
}

typealias ESFactory = Factory
