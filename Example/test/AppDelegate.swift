/*
 * Game Of Whales SDK
 *
 * https://www.gameofwhales.com/
 *
 * Copyright © 2018 GameOfWhales. All rights reserved.
 *
 * Licence: https://www.gameofwhales.com/licence
 *
 */

import UIKit
import StoreKit
import GameOfWhales
import Firebase
import UserNotifications;

extension Notification.Name {
    static let FIRRemoteMessageReceived = Notification.Name("FIRRemoteMessageReceived")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FIRMessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog("GOW.Example: didFinishLaunchingWithOptions %@", launchOptions ?? "");
        let gamekey = your_gamekey_there;
        GW.initialize(withGameKey: gamekey, launchOptions, true);
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                { (granted, error) in
                    if granted == true{
                        DispatchQueue.main.async {
                            NSLog("GOW.Example: Granted")
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    if let error = error {
                        NSLog("GOW.Example: Error: \(error.localizedDescription)")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        
        
        NSLog("GOW.Example: transactions count = %@", SKPaymentQueue.default().transactions.count);
        
        SKPaymentQueue.default().restoreCompletedTransactions();

        return true
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage){
        let n = Notification(name: .FIRRemoteMessageReceived, object: remoteMessage.appData);
        NotificationCenter.default.post(n);
    }

    func firConnect() {
     
    }
    
        
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect();
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        firConnect();
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("GOW.Example: token", deviceTokenString)
        
        GW.registerDeviceToken(with: deviceTokenString, provider: GW_PROVIDER_APN)
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        print("GOW.Example: didFailToRegisterForRemoteNotificationsWithError ", error);
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        print("GOW.Example: didReceiveRemoteNotification ");
        GW.receivedRemoteNotification(userInfo, with: application, fetchCompletionHandler: completionHandler); 
    }
    
    
}



