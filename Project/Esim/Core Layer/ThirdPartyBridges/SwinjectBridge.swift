//
//  IAssemblerApplyable.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import Swinject

final class AssemblerBridge: IAssemblerBridgeable {
	let assembler: Assembler
	
	init(_ assemblies: [Assembly], container: Container = Container()) {
		self.assembler = Assembler(assemblies, container: container)
	}
}

protocol IAssemblerBridgeable {
	var assembler: Assembler { get }
	func apply(assemblies: [Assembly])
	func forceResolve<Service>(_ serviceType: Service.Type, name: String?) -> Service
	func forceResolve<Service>(_ serviceType: Service.Type) -> Service
}

extension IAssemblerBridgeable {
	func apply(assemblies: [Assembly]) {
		assembler.apply(assemblies: assemblies)
	}
	
	func forceResolve<Service>(_ serviceType: Service.Type) -> Service {
		assembler.resolver.resolve(serviceType)! // swiftlint:disable:this force_unwrapping
	}
	
	func forceResolve<Service>(_ serviceType: Service.Type, name: String?) -> Service {
		assembler.resolver.resolve(serviceType, name: name)! // swiftlint:disable:this force_unwrapping
	}

}


protocol IAssemblyBridgeable where Self: Assembly {
	func assemble(container: IContainerApplyable)
}

extension IAssemblyBridgeable {
	func assemble(container: Container) {
		assemble(container: container)
	}
	func assemble(container: IContainerApplyable) {
		assemble(container: container)
	}
}

protocol IContainerApplyable where Self: Container {
	func register<Service>(
		_ serviceType: Service.Type,
		factory: @escaping (Resolver) -> Service
	) -> ServiceEntry<Service>
}


extension Assembler {
	func forceResolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service {
		resolver.resolve(serviceType, name: name)! // swiftlint:disable:this force_unwrapping
	}
}
