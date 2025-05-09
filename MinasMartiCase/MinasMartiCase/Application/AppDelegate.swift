//
//  AppDelegate.swift
//  MinasMartiCase
//
//  Created by Mina Namlı on 8.05.2025.
//

import UIKit
import Network

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var monitor: NWPathMonitor?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainPage()
        
        window?.makeKeyAndVisible()
        startNetworkMonitoring()
        return true
    }

    func startNetworkMonitoring() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if !(path.status == .satisfied) {
                    let alertController = UIAlertController(title: Constants.AppStr.networkErrTitle, message: Constants.AppStr.networkErrMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: Constants.AppStr.ok, style: .default))
                    if let viewController = self?.window?.rootViewController {
                        viewController.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        monitor?.start(queue: queue)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        monitor?.cancel()
    }
}

