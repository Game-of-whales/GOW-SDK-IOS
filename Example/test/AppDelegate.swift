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

struct ExperimentPayload: Decodable {
    let ignore: Bool
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FIRMessagingDelegate, GWDelegate {
    
    static var experimentString:String = "nothing";

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog("GOW.Example: didFinishLaunchingWithOptions %@", launchOptions ?? "");
        let nonPersonal = false;
        let debugLog = true;
        
        
        GW.initialize(withGameKey: "585026b7f365603dd4e70d4d", launchOptions, debugLog, nonPersonal);
        
        GW.add(self);
        //GW.initialize(launchOptions, true);

        
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
        
        let exp = GW.getCurrentExperiment();
        
        if (exp != nil)
        {
            AppDelegate.experimentString = "ACTIVE: " + exp!.save();
        }
        
        //GW.getCur

        /*FIRMessaging.messaging().remoteMessageDelegate = self
        
        FIRApp.configure()
        
        firConnect()*/
        
        //GW.setPushNotificationsEnable(true);

        return true
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage){
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
    
    static func GetExperimentString() -> String {
        return experimentString;
    }
    
    //GOW DELEGATE
    func specialOfferAppeared(_ specialOffer: GWSpecialOffer) {
        
    }
    
    func specialOfferDisappeared(_ specialOffer: GWSpecialOffer) {
        
    }
    
    func futureSpecialOfferAppeared(_ specialOffer: GWSpecialOffer) {
        
    }
    
    func onPushDelivered(_ specialOffer: GWSpecialOffer?, camp: String, title: String, message: String) {
        
    }
    
    func onPurchaseVerified(_ transactionID: String, state: String) {
        
    }
    
    func onAdLoaded() {
        
    }
    
    func onAdLoadFailed() {
        
    }
    
    func onAdClosed() {
        
    }
    
    func onInitialized() {
        
    }
    
    func canStart(_ experiment: GWExperiment) -> Bool {
        
        let data = experiment.payload.data(using: .utf8);
        
        let payload = try? JSONDecoder().decode(ExperimentPayload.self, from: data!);
        
        if (payload != nil && payload!.ignore)
        {
            AppDelegate.experimentString = "IGNORED: " + experiment.save();
            return false;
        }
        
        AppDelegate.experimentString = "STARTED: " + experiment.save();
        return true;
    }
    
    func onExperimentEnded(_ experiment: GWExperiment) {
        AppDelegate.experimentString = "ENDED: " + experiment.save();
    }
}



