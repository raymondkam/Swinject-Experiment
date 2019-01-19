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

protocol RequiredObjectADependencies: RequiredDependencies {
    var key: Key { get }
}

final class ObjectAAssembly: Assembly {

//    let requiredDependencies: () -> RequiredDependencies
//
//    init(requiredDependencies: @escaping () -> RequiredObjectADependencies) {
//        self.requiredDependencies = requiredDependencies
//    }

    func assemble(container: Container) {
        container.register(ObjectA.self) { resolver in
            let requiredDependenices = resolver.resolve(RequiredObjectADependencies.self)!
            return ObjectA(key: requiredDependenices.key)
        }
    }
}

final class ObjectBAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ObjectB.self) { resolver in
            return ObjectB()
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
