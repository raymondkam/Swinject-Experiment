//
//  TestObjects.swift
//  Swinject-Test
//
//  Created by Raymond Kam on 2019-01-18.
//  Copyright © 2019 Raymond Kam. All rights reserved.
//

import Foundation

class ObjectA {
    let key: Key
    let reporter: Reporter
    let objectC: ObjectC

    init(key: Key, reporter: Reporter, objectC: ObjectC) {
        self.key = key
        self.reporter = reporter
        self.objectC = objectC
    }
}

class ObjectB {
    init() {}
}

class ObjectC {
    init() {}
}

class Key {
    let value: String

    init(value: String) {
        self.value = value
    }
}

class Reporter {
    let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }
}

protocol Logger {
    func log(message: String)
}

class InfoLogger: Logger {
    init() {}

    func log(message: String) {
        print("INFO: \(message)")
    }
}

class ErrorLogger: Logger {
    init() {}

    func log(message: String) {
        print("ERROR: \(message)")
    }
}
