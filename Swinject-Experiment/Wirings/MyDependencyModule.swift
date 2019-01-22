//
//  MyDependencyModule.swift
//  Swinject-Test
//
//  Created by Raymond Kam on 2019-01-18.
//  Copyright © 2019 Raymond Kam. All rights reserved.
//

import Foundation
import Swinject

class MyDependencyModule {

    var assembler: Assembler

    init() {
        let dependenciesContainer = Container()
        MyDependencyModule.attachDependencies(to: dependenciesContainer)

        let finalAssemblies: [Assembly] = [
            ObjectAAssembly(
                keyResolver: DependencyResolver<Key>(dependenciesContainer),
                reporterResolver: DependencyResolver<Reporter>(dependenciesContainer),
                objectCResolver: DependencyResolver<ObjectC>(dependenciesContainer)
            ),
            ObjectBAssembly(keyResolver: DependencyResolver<Key>(dependenciesContainer))
        ]
        let finalAssembler = Assembler(finalAssemblies)

        assembler = finalAssembler
    }

    static func attachDependencies(to container: Container) {
        container.register(Key.self) { _ in
            print("factory create key")
            return Key(value: "My App Key")
        }.inObjectScope(.container)
        container.register(Logger.self) { _ in
            return ErrorLogger()
        }.inObjectScope(.container)
        container.register(Reporter.self) { resolver in
            return Reporter(logger: resolver.resolve(Logger.self)!)
        }.inObjectScope(.container)
        ObjectCAssembly().assemble(container: container)
    }

}
