//
//  AppDelegate.swift
//  test
//
//  Created by Dmitry Burlakov on 26.09.16.
//  Copyright © 2016 GameOfWhales. All rights reserved.
//

import UIKit
import StoreKit
import GameOfWhales
import Firebase
import UserNotifications;

extension Notification.Name {
    static let FIRRemoteMessageReceived = Notification.Name("FIRRemoteMessageReceived")
}

@UIApplicationMain
class AppDelegate: MessagingRemoteMessage, UIApplicationDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog("GOW.Example: didFinishLaunchingWithOptions %@", launchOptions ?? "");
        
        GW.initialize(withGameKey: "585026b7f365603dd4e70d4d", launchOptions, true);
        //GW.initialize(launchOptions, true);

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            if granted == true{
                NSLog("GOW.Example: Granted")
                UIApplication.shared.registerForRemoteNotifications()
            }
            if let error = error {
                NSLog("GOW.Example: Error: \(error.localizedDescription)")
            }
        }
        
        
        NSLog("GOW.Example: transactions count = %@", SKPaymentQueue.default().transactions.count);
        
        SKPaymentQueue.default().restoreCompletedTransactions();

        /*FIRMessaging.messaging().remoteMessageDelegate = self
        
        FIRApp.configure()
        
        firConnect()*/

        return true
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage){
        let n = Notification(name: .FIRRemoteMessageReceived, object: remoteMessage.appData);
        NotificationCenter.default.post(n);
    }

    func firConnect() {
        /*let token = FIRInstanceID.instanceID().token();
        
        if (token == nil)
        {
            print("GOW.Example: firConnect token is null")
            return;
        }
        
        FIRMessaging.messaging().disconnect();
        
        FIRMessaging.messaging().connect { (error:Error?) in
            if ((error) != nil) {
                print("GOW.Example: Unable to connect to FCM.", error ?? "")
            } else {
                print("GOW.Example: Connected to FCM")
            }
        };
        
        GW.shared().registerDeviceToken(with: token!, provider:GW_PROVIDER_FCM);*/
    }
    
        
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().disconnect();
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
        
        /*let controller = self.window?.rootViewController as! ViewController
        controller.OnRemoteNotificationReceived(notification: userInfo)*/

        GW.receivedRemoteNotification(userInfo, with: application, fetchCompletionHandler: completionHandler);
        
       /* if (application.applicationState == UIApplicationState.active)
        {
            let alert = UIAlertController(title: "Notification", message: "", preferredStyle: UIAlertControllerStyle.alert);
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil);
            alert.addAction(ok)
            controller.present(alert, animated: true, completion: {
                GW.shared().reactedRemoteNotification(userInfo);
            })
        }*/
                
    }
    
    
}



