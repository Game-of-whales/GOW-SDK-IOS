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

#import "AppDelegate.h"
#import <GameOfWhales/GameOfWhales.h>

@import Firebase;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
   // [[GW shared] launchWithOptions:launchOptions];
    if ([GW IsAdLoaded])
        [GW ShowAd];
        else
        [GW LoadAd];
    
    BOOL nonPersonal = TRUE;
    BOOL debugLog = TRUE;
    [GW Initialize:launchOptions :debugLog :nonPersonal];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [GW RegisterDeviceTokenWithData:deviceToken provider:GW_PROVIDER_APN];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [GW ReceivedRemoteNotification:userInfo withApplication:application fetchCompletionHandler:completionHandler];
    
    //NSString * pushID = [[GWManager sharedManager] getPushID:userInfo];
    
    //[[GW shared] pushReacted:pushID];
    
    SKProduct * skproduct;
    
    NSString *product = @"product_10";
    NSString *currency = @"USD";
    double price = 1.99;
    
    [GW Purchase:product :currency :price];
    
   /*NSMutableDictionary *changes = [NSMutableDictionary dictionary];
    changes[@"coins"] = @1000;
    changes[@"class"] = @"wizard";
    changes[@"gender"] = @TRUE;
    changes[@"location"] = @"A";
    [GW Profile:changes];*/
    
    [GW SetPushNotificationsEnable:false];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    /* for(SKPaymentTransaction * t in transactions)
         if (t.transactionState == SKPaymentTransactionStatePurchased)
                 [[GW shared] purchaseTransaction:t product:product];
     */
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
