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

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        objectA = appDelegate.resolver.resolve(ObjectA.self)
        print(objectA.key.value)
        objectA.reporter.logger.log(message: "Hello world!")
    }


}

