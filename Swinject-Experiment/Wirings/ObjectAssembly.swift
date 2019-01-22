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

class DependencyProvider<T> {
    let factory: () -> T

    init(factory: @escaping () -> T) {
        self.factory = factory
    }
}

class DependencyResolver<T> {
    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    var value: T {
        return resolver.resolve(T.self)!
    }
}

class RequiredObjectADependencies: RequiredDependencies {
    var key: DependencyProvider<Key>
    var reporter: DependencyProvider<Reporter>
    var objectC: DependencyProvider<ObjectC>

    init(key: DependencyProvider<Key>, reporter: DependencyProvider<Reporter>, objectC: DependencyProvider<ObjectC>) {
        self.key = key
        self.reporter = reporter
        self.objectC = objectC
    }

    func assemble(container: Container) {
        container.register(RequiredObjectADependencies.self) { [key, reporter, objectC] _ in
            return RequiredObjectADependencies(key: key, reporter: reporter, objectC: objectC)
        }
    }
}

final class ObjectAAssembly: Assembly {

    let requiredDependencies: RequiredObjectADependencies

    init(requiredDependencies: RequiredObjectADependencies) {
        self.requiredDependencies = requiredDependencies
    }

    func assemble(container: Container) {
        requiredDependencies.assemble(container: container)
        container.register(ObjectA.self) { resolver in
            let dependencies = resolver.resolve(RequiredObjectADependencies.self)!
            print("create object A")
            return ObjectA(
                key: dependencies.key.factory(),
                reporter: dependencies.reporter.factory(),
                objectC: dependencies.objectC.factory()
            )
        }
    }
}

class ObjectBDependencies: RequiredDependencies {
    var keyResolver: DependencyResolver<Key>

    init(keyResolver: DependencyResolver<Key>) {
        self.keyResolver = keyResolver
    }

    func assemble(container: Container) {
        container.register(ObjectBDependencies.self) { [keyResolver] _ in
            return ObjectBDependencies(keyResolver: keyResolver)
        }
    }
}

final class ObjectBAssembly: Assembly {

    let dependencies: ObjectBDependencies

    init(dependencies: ObjectBDependencies) {
        self.dependencies = dependencies
    }

    func assemble(container: Container) {
        dependencies.assemble(container: container)
        container.register(ObjectB.self) { resolver in
            let dependencies = resolver.resolve(ObjectBDependencies.self)!
            print("create object b")
            return ObjectB(key: dependencies.keyResolver.value)
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
