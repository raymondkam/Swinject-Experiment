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
    let factory: (Container) -> T

    init(factory: @escaping (Container) -> T) {
        self.factory = factory
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
                key: dependencies.key.factory(container),
                reporter: dependencies.reporter.factory(container),
                objectC: dependencies.objectC.factory(container)
            )
        }
    }
}

class RequiredObjectBDependencies: RequiredDependencies {
    var key: DependencyProvider<Key>

    init(key: DependencyProvider<Key>) {
        self.key = key
    }

    func assemble(container: Container) {
        container.register(Key.self) { [key] _ in
            print("create for object b")
            return key.factory(container)
        }
    }
}

final class ObjectBAssembly: Assembly {

    let requiredDependencies: RequiredObjectBDependencies

    init(requiredDependencies: RequiredObjectBDependencies) {
        self.requiredDependencies = requiredDependencies
    }

    func assemble(container: Container) {
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
