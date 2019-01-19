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

    init(key: Key) {
        self.key = key
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
