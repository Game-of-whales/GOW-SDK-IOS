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
import UserNotifications;
import Firebase

extension Notification.Name {
    static let FIRRemoteMessageReceived = Notification.Name("FIRRemoteMessageReceived")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    

    func purchasedReplacement(_ replacement: GWReplacement, transaction: SKPaymentTransaction) {
        NSLog("GOW.Example: App delegate - %@  purchased", replacement);
    }
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog("GOW.Example: didFinishLaunchingWithOptions %@", launchOptions.debugDescription);
        
        
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
        
        GWManager.setDebug(true)
        GWManager.shared().launch(options: launchOptions)
        
        NSLog("GOW.Example: transactions count = %@", SKPaymentQueue.default().transactions.count);
        
        SKPaymentQueue.default().restoreCompletedTransactions();
        
        Messaging.messaging().delegate = self
        
        FirebaseApp.configure()
        
        firConnect()
        
        return true
    }
    
    func application(received remoteMessage: MessagingRemoteMessage){
        let n = Notification(name: .FIRRemoteMessageReceived, object: remoteMessage.appData);
        NotificationCenter.default.post(n);
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        GWManager.shared().updateDeviceToken(fcmToken);
    }
    
    func firConnect() {
        let token = InstanceID.instanceID().token();
        
        if (token == nil)
        {
            print("GOW.Example: firConnect token is null")
            return;
        }
        
        Messaging.messaging().disconnect();
        
        Messaging.messaging().connect { (error:Error?) in
            if ((error) != nil) {
                print("GOW.Example: Unable to connect to FCM.", error ?? "")
            } else {
                print("GOW.Example: Connected to FCM")
            }
        };
        
        GWManager.shared().updateDeviceToken(token);
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
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        print("GOW.Example: didFailToRegisterForRemoteNotificationsWithError ", error);
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        print("GOW.Example: didReceiveRemoteNotification ");
        
        let controller = self.window?.rootViewController as! ViewController
        controller.OnRemoteNotificationReceived(notification: userInfo)
        
        GWManager.shared().receivedRemoteNotification(userInfo, with: application, fetchCompletionHandler: completionHandler);
        
        if (application.applicationState == UIApplicationState.active)
        {
            let pushID = GWManager.shared().getPushID(userInfo);
            
            let alert = UIAlertController(title: "Notification", message: "", preferredStyle: UIAlertControllerStyle.alert);
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil);
            alert.addAction(ok)
            controller.present(alert, animated: true, completion: {
                GWManager.shared().pushReacted(pushID);
            })
        }

    }
    
    
}



