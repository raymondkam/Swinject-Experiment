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

class RequiredObjectADependencies: RequiredDependencies {
    var key: Key
    var reporter: Reporter
    var objectC: ObjectC

    init(key: Key, reporter: Reporter, objectC: ObjectC) {
        self.key = key
        self.reporter = reporter
        self.objectC = objectC
    }

    func assemble(container: Container) {
        container.register(Key.self) { [key] _ in
            return key
        }
        container.register(Reporter.self) { [reporter] _ in
            return reporter
        }
        container.register(ObjectC.self) { [objectC] _ in
            return objectC
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
            return ObjectA(
                key: resolver.resolve(Key.self)!,
                reporter: resolver.resolve(Reporter.self)!,
                objectC: resolver.resolve(ObjectC.self)!
            )
        }
    }
}

class RequiredObjectBDependencies: RequiredDependencies {
    var key: Key

    init(key: Key) {
        self.key = key
    }

    func assemble(container: Container) {
        container.register(Key.self) { [key] _ in
            return key
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
