//
//  MyDependencyModule.swift
//  Swinject-Test
//
//  Created by Raymond Kam on 2019-01-18.
//  Copyright © 2019 Raymond Kam. All rights reserved.
//

import Foundation
import Swinject

class MyRequiredObjectADependencies: RequiredObjectADependencies {
    var key: Key

    init(key: Key) {
        self.key = key
    }

    func assemble(container: Container) {
        container.register(RequiredObjectADependencies.self) { [self] _ in
            return self
        }
        container.register(Key.self) { [key] _ in
            return key
        }
    }
}

class MyDependencyModule {

    var assembler: Assembler

    init() {
//        let requiredAssemblies: [Assembly] = [
//            MyRequiredObjectADependencies(key: Key(value: "My Key"))
//        ]
//        let requiredDependenciesAssembler = Assembler(requiredAssemblies)
        let objectADependencies = MyRequiredObjectADependencies(key: Key(value: "My Key"))
        let finalAssemblies: [Assembly] = [
            objectADependencies,
            ObjectAAssembly(),
//            ObjectAAssembly(requiredDependencies: { () -> RequiredObjectADependencies in
//                return objectADependencies
//            }),
            ObjectBAssembly(),
            ObjectCAssembly()
        ]
        let finalAssembler = Assembler(finalAssemblies)

        assembler = finalAssembler
    }

}
