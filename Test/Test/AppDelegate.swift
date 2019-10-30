//
//  AppDelegate.swift
//  Test
//
//  Created by Artem Orlov on 26/10/2019.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let dog = Animal(name: "Rex", legCount: 4)
        let cat = Animal(name: "Barcik", legCount: 3)

        let spider = Animal(name: "Piter", legCount: -8)

        let animals = [dog, cat, spider]
        for animal in animals {
            guard let newAnimal = animal else { break }
            newAnimal.move()
            //animal!.move()
        }

        return true
    }
}
