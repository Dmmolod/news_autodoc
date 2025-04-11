//
//  AppDelegate.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
}

// MARK: - Life cycle -
extension AppDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let appDependencies = AppDependenciesFactory.buildAppDependeincies(config: config)
        AppFlow.setAppFlow(in: window, appDeps: appDependencies)
        window.makeKeyAndVisible()
        
        return true
    }
}


let config: AppConfiguration = {
#if APPSTORE
    return AppConfigurationAppStore()
#endif
}()

protocol AppConfiguration {
    var baseUrl: URL { get }
    var imageBaseUrl: URL { get }
}

struct AppConfigurationAppStore: AppConfiguration {
    var baseUrl: URL { URL(string: "https://webapi.autodoc.ru/api")! }
    var imageBaseUrl: URL { URL(string: "https://file.autodoc.ru")! }
}
