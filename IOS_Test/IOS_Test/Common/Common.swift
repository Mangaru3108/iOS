//
//  Common.swift
//  MvvmDemoApp
//
//  Created by CodeCat15 on 3/14/20.
//  Copyright © 2020 Codecat15. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let ErrorAlertTitle = "Error"
    static let ErrorAlertMessage = "Something Went Wrong.No Joke Found"
    static let JokeUserDefaultKey = "jokes"
    static let JokesLimit = 10
    static let Joke_ApiCall_Interval = 5
}
struct ApiEndpoints
{
    static let joke = "https://geek-jokes.sameerkumar.website/api"
}

struct UserDefaultsManager {
    static func saveJokes(_ jokes: [Joke]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(jokes) {
            UserDefaults.standard.set(encodedData, forKey: Constants.JokeUserDefaultKey)
        }
    }
    
    static func loadJokes() -> [Joke]? {
        guard let storedJokes = UserDefaults.standard.value(forKey: Constants.JokeUserDefaultKey) as? Data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode([Joke].self, from: storedJokes)
    }
}


func showAlert(title:String,message:String) {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let topWindow = windowScene.windows.first,
       let topViewController = topWindow.rootViewController?.topMostViewController() {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        topViewController.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController() ?? self
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}

