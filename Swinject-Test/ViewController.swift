//
//  ViewController.swift
//  Swinject-Test
//
//  Created by Raymond Kam on 2019-01-18.
//  Copyright © 2019 Raymond Kam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var objectA: ObjectA!
    var objectA2: ObjectA!

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        objectA = appDelegate.resolver.resolve(ObjectA.self)!
        print(objectA.key.value)
        objectA.reporter.logger.log(message: "Hello world!")

        objectA2 = appDelegate.resolver.resolve(ObjectA.self)!
        print(objectA2.key.value)
        objectA2.reporter.logger.log(message: "Hello world 2!")
    }


}

