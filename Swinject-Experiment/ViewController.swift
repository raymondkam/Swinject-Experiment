//
//  ViewController.swift
//  Swinject-Test
//
//  Created by Raymond Kam on 2019-01-18.
//  Copyright © 2019 Raymond Kam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let objectA = appDelegate.resolver!.resolve(ObjectA.self)!
        print(objectA.key.value)
        objectA.reporter.logger.log(message: "Hello world!")

        let objectA2 = appDelegate.resolver!.resolve(ObjectA.self)!
        print(objectA2.key.value)
        objectA2.reporter.logger.log(message: "Hello world 2!")

        appDelegate.resolver = nil
        appDelegate.assembler = nil
    }
}

