//
//  MyDependentAssembly.swift
//  Swinject-Test
//
//  Created by Raymond Kam on 2019-01-18.
//  Copyright © 2019 Raymond Kam. All rights reserved.
//

import Foundation
import Swinject

protocol RequiredDependencies: Assembly {}

class Registry<T> {
    let resolver: Resolver

    init(_ resolver: Resolver) {
        self.resolver = resolver
    }

    func forwardRegistration(to container: Container, scope: ObjectScope = .graph) {
        container.register(T.self) { [resolver] _ in
            return resolver.resolve(T.self)!
        }
        .inObjectScope(scope)
    }
}

class DependencyProvider<T> {
    let factory: () -> T

    init(factory: @escaping () -> T) {
        self.factory = factory
    }
}

class DependencyResolver<T> {
    private let resolver: Resolver

    init(_ resolver: Resolver) {
        self.resolver = resolver
    }

    var value: T {
        return resolver.resolve(T.self)!
    }
}

final class ObjectAAssembly: Assembly {

    let keyRegistry: Registry<Key>
    let reporterRegistry: Registry<Reporter>
    let objectCRegistry: Registry<ObjectC>

    init(keyRegistry: Registry<Key>,
         reporterRegistry: Registry<Reporter>,
         objectCRegistry: Registry<ObjectC>) {
        self.keyRegistry = keyRegistry
        self.reporterRegistry = reporterRegistry
        self.objectCRegistry = objectCRegistry
    }

    func assemble(container: Container) {
        keyRegistry.forwardRegistration(to: container)
        reporterRegistry.forwardRegistration(to: container)
        objectCRegistry.forwardRegistration(to: container)
        container.register(ObjectA.self) { resolver in
            print("create object A")
            return ObjectA(
                key: resolver.resolve(Key.self)!,
                reporter: resolver.resolve(Reporter.self)!,
                objectC: resolver.resolve(ObjectC.self)!
            )
        }
    }
}

final class ObjectBAssembly: Assembly {

    let keyRegistry: Registry<Key>

    init(keyRegistry: Registry<Key>) {
        self.keyRegistry = keyRegistry
    }

    func assemble(container: Container) {
        keyRegistry.forwardRegistration(to: container)
        container.register(ObjectB.self) { resolver in
            print("create object b")
            return ObjectB(key: resolver.resolve(Key.self)!)
        }
    }
}

final class ObjectCAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ObjectC.self) { resolver in
            return ObjectC()
        }
    }
}
