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
        let appContainer = Container()
        MyDependencyModule.attachAppDependencies(to: appContainer)

        let finalAssemblies: [Assembly] = [
            ObjectAAssembly(
                requiredDependencies: RequiredObjectADependencies(
                    key: appContainer.resolve(Key.self)!,
                    reporter: appContainer.resolve(Reporter.self)!,
                    objectC: appContainer.resolve(ObjectC.self)!
                )
            ),
            ObjectBAssembly()
        ]
        let finalAssembler = Assembler(finalAssemblies, container: appContainer)

        assembler = finalAssembler
    }

    static func attachAppDependencies(to container: Container) {
        container.register(Logger.self) { _ in
            return ErrorLogger()
        }
        container.register(Reporter.self) { resolver in
            return Reporter(logger: resolver.resolve(Logger.self)!)
        }
        container.register(Key.self) { _ in
            return Key(value: "My App Key")
        }
        ObjectCAssembly().assemble(container: container)
    }

}
