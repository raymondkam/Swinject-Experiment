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

    init(_ resolver: Resolver) {
        self.resolver = resolver
    }

    var value: T {
        return resolver.resolve(T.self)!
    }
}

final class ObjectAAssembly: Assembly {

    let keyResolver: DependencyResolver<Key>
    let reporterResolver: DependencyResolver<Reporter>
    let objectCResolver: DependencyResolver<ObjectC>

    init(keyResolver: DependencyResolver<Key>,
         reporterResolver: DependencyResolver<Reporter>,
         objectCResolver: DependencyResolver<ObjectC>) {
        self.keyResolver = keyResolver
        self.reporterResolver = reporterResolver
        self.objectCResolver = objectCResolver
    }

    func assemble(container: Container) {
        container.register(ObjectA.self) { [keyResolver, reporterResolver, objectCResolver] resolver in
            print("create object A")
            return ObjectA(
                key: keyResolver.value,
                reporter: reporterResolver.value,
                objectC: objectCResolver.value
            )
        }
    }
}

final class ObjectBAssembly: Assembly {

    let keyResolver: DependencyResolver<Key>

    init(keyResolver: DependencyResolver<Key>) {
        self.keyResolver = keyResolver
    }

    func assemble(container: Container) {
        container.register(ObjectB.self) { [keyResolver] resolver in
            print("create object b")
            return ObjectB(key: keyResolver.value)
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
