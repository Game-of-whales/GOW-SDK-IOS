# GOW-SDK-IOS

# Download

Download the latest sdk version from our server:

[<img src=https://github.com/Game-of-whales/GOW-SDK-UNITY/wiki/img/download.png>](https://github.com/Game-of-whales/GOW-SDK-IOS/archive/v2.0.11.zip)

# Changelog

### 2.0.11

MODIFIED

* Push notification about special offer comes at the same time with the special offer (new parameter _offer_ was added):<br/>
``void onPushDelivered(SpecialOffer offer, String campID, String title, String message);``

* ``setPushNotificationsEnable`` method was added to allow user to turn off the push notifications.

* Added static methods instead of _shared_ methods.


### 2.0.10

FIXED
* _pushReacted_ sending with empty _camp_.


### 2.0.9

MODIFIED
* renamed "Reachability" class to "GWReachability".


### 2.0.8

FIXED
* bug with _pushDelivered_ and _pushReacted_ events for push campaigns.


### 2.0.7

FIXED
* bug with ```OnPushDelivered``` callback for empty push notification campaign.
* bug with redeemable once special offer: they could be used many times.


# Implementation Guide

* [Common](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#common)
* [For SWIFT](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#swift)
* [For Objective-С](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#objective-c)
* [FAQ](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#faq)



## Common

### Step 1

Add ```GameOfWhales.framework``` to ```Linked Frameworks and Libraries``` XCODE section of your project. 

<img src=http://www.gameofwhales.com/sites/default/files/documentation/add_framework.png>

### Step 2
Add ```GWGameKey``` parameter to ```info.plist``` and specify your [game key](http://www.gameofwhales.com/documentation/game).
 
<img src=http://www.gameofwhales.com/sites/default/files/documentation/game_key.png>




## SWIFT

### Step 3
Call a method ```launch``` when you launch your app.

```swift
import GameOfWhales
...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
{
  ...
   Bool debugLog = false;
   GW.initialize( launchOptions, false);

```

### Step 4 (only if you use in-app purchases)
Register a purchase with ``purchaseTransaction`` method.

```swift
 func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for t in transactions
       if t.transactionState == SKPaymentTransactionState.purchased
           GW.purchaseTransaction(t, product: product!);
```

## Special Offers

### Step 5

If you want to use [special offers](http://www.gameofwhales.com/documentation/special-offers), you need to implement some methods of ```GWDelegate``` protocol and call ```add``` method.

```swift
class ViewController: UIViewController, GWDelegate     
...

     override func viewWillAppear(_ animated: Bool) {
         GWManager.add(self)
     }
   
     override func viewDidDisappear(_ animated: Bool) {
     
        //remove self from delegates
        GWManager.remove(self)

```

### Step 6
Add the following methods:

```swift
 func onPurchaseVerified(_ transactionID: String, state: String)
 {
 }
 
 func specialOfferDisappeared(_ specialOffer: GWSpecialOffer)
 {
 }
 
 func specialOfferAppeared(_ specialOffer: GWSpecialOffer) 
 {
 }
 
 func onPushDelivered(_ offer:GWSpecialOffer?, camp: String, title:String, message:String)
 {
 }
```

### Step 7
In order to receive a special offer call the following method:

```swift
   let offer = GW.getSpecialOffer(productIdentifier);
   if (offer != nil)
   {   ...
```

A special offer can influence a product's price:
```swift
   if (offer?.hasPriceFactor())!
   {
       price = Int(Float(price) * (offer?.priceFactor)!);
   }
```


A special offer can also influence count (count of coins, for example) which a player receive by purchase:
```swift
   if (offer?.hasCountFactor())!
   {
       coins = Int(Float(coins) * (offer?.countFactor)!);
   }
```

## Notifications

### Step 8

In order to send notifications from GOW server it is necessary to pass the token information to the server.

```swift
    //FIREBASE
    let token = FIRInstanceID.instanceID().token();
    GW.registerDeviceToken(with: token!, provider:GW_PROVIDER_FCM);
    
    //APN
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        GW.registerDeviceToken(with: deviceToken, provider: GW_PROVIDER_APN)
```

### Step 9

To get information about a player's reaction on notifications add the following methods to ```AppDelegate```:

```swift
func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
                     {
                     
                     GWManager.receivedRemoteNotification(userInfo, with: application, fetchCompletionHandler: completionHandler);
                     
                     }
```

### Step 10 (Only if notifications are shown inside your app by using the game's code)

In order to send the information to _Game of Whales_ regarding a player's reaction on a notification (to increase push campaign's _Reacted_ field) of an already started app call the following method:

```swift
      func onPushDelivered(_ offer:GWSpecialOffer?, camp: String, title:String, message:String) {
            //Show message and call:
            GW.reactedRemoteNotification(withCampaign: camp);
```

### Step 11

In order to enable or disable push notifications, use the following method:

```swift
   GW.setPushNotificationsEnable(false);
```

## Profiles

### Step 12

``profile`` method should be called if key parameters of your app or a player have changed.

For example:
```swift
    GW.profile(["coins":1000, "class":"wizard", "gender":true, "locatiom":"A"]);
 ```

## Converting

### Step 13

``converting`` method should be called when you buy or get some in-game objects, coins, currency, etc.

For example:

Someone bought one _bike_1_ for _1000_ coins and _50_ gas. You should call the following method for this purchase:
```swift
      GW.converting(["coins":-1000, "gas":-50, "bike_1":1], place: "bank")
```

You can also use the following methods:

``consume`` - to buy items for game currency. For example:

```swift
    GW.consumeCurrency("coins", number:1000, sink:"gas", amount:50, place:"shop")
```

``acquire`` - for in-app purchases. It's important to call ``acquire`` method after ``InAppPurchased``. For example:

```swift
    GW.acquireCurrency("coins", amount:1000, source:sku, number:1, place:"bank")
```



# Objective-C

### Step 3
Call a method ```launchWithOptions``` when you launch your app.

```objective-c
#import <GameOfWhales/GameOfWhales.h>
...
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...
    BOOL debugLog = false;
    [GW initialize:launchOptions :debugLog];
```

### Step 4 (only if you use in-app purchases)
Register a purchase with ``purchaseTransaction`` method.

```objective-c
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
     for(SKPaymentTransaction * t in transactions)
         if (t.transactionState == SKPaymentTransactionStatePurchased)
                 [GW PurchaseTransaction:t product:product];
}
```

## Special Offers

### Step 5

If you want to use [special offers](http://www.gameofwhales.com/documentation/special-offers), you need to implement some methods of ```GWDelegate``` protocol and call ```addDelegate``` method.

```objective-c
@interface ViewController : UIViewController<GWDelegate>
...
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GW AddDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [GW RemoveDelegate:self];
}

```

### Step 6
Add the following methods:

```objective-c
- (void)specialOfferAppeared:(nonnull GWSpecialOffer *)specialOffer
{
    
}

- (void)specialOfferDisappeared:(nonnull GWSpecialOffer *)specialOffer
{
    
}

- (void)onPushDelivered:(nullable GWSpecialOffer*) offer camp:(nonnull NSString *)camp title:(nonnull NSString*)title message:(nonnull NSString*)message
{
    
}

- (void)onPurchaseVerified:(nonnull NSString*)transactionID state:(nonnull NSString*)state
{
    
}
```

### Step 7

In order to receive a special offer call the following method: 

```objective-c
    GWSpecialOffer* so = [GW GetSpecialOffer:productIdentifer];
    if (so != nil)
    {
      ...
    }
    
 ```

 A special offer can influence a product's price:
```objective-c
   if ([so hasPriceFactor])
   {
       price *= so.priceFactor;
   }
 ```
 
A special offer can also influence count (count of coins, for example) which a player receive by purchase:
```objective-c
   if ([so hasCountFactor])
   {
       coins *= so.countFactor;
   }
 ```
## Notifications

### Step 8

In order to send notifications from GOW server it is necessary to pass the token information to the server.

```objective-c
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 
    //FIREBASE
    [GW RegisterDeviceTokenWithString:[[FIRInstanceID instanceID] token] provider:GW_PROVIDER_FCM];
    
    //APN
    [GW RegisterDeviceTokenWithData:deviceToken provider:GW_PROVIDER_APN];
}
```

### Step 9
To get information about a player's reaction on notifications add the following methods to ```AppDelegate```:

```objective-c
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
   {
     [GW ReceivedRemoteNotification:userInfo withApplication:application fetchCompletionHandler:completionHandler]; 
   }
 ```

### Step 10 (Only if notifications are shown inside your app by using the game's code)
In order to send the information to *Game of Whales* regarding a player's reaction on a notification (to increase push campaign's Reacted field) of an already started app call the following method:

```objective-c
- (void)onPushDelivered:(nullable GWSpecialOffer*) offer camp:(nonnull NSString *)camp title:(nonnull NSString*)title message:(nonnull NSString*)message
{
    //Show the notification to a player and then call the following method
    [GW ReactedRemoteNotificationWithCampaign:camp];
}
```

### Step 11

In order to enable or disable push notifications, use the following method:

```objective-c
  [GW SetPushNotificationsEnable:false];
```


## Profiles

### Step 12

``Profile`` method should be called if key parameters of your app or a player have changed.
 
 For example:
 
 ```objc
     NSMutableDictionary *changes = [NSMutableDictionary dictionary];
     message[@"coins"] = @1000;
     message[@"class"] = @"wizard";
     message[@"gender"] = @TRUE;
     message[@"location"] = @"A";
     [GW Profile:changes];
 ```

## Converting

### Step 13

``Converting`` method should be called when you buy or get some in-game objects, coins, currency, etc.

For example:

Someone bought one _bike_1_ for _1000_ coins and _50_ gas. You should call the following method for this purchase:

```objc
        NSMutableDictionary *resources = [NSMutableDictionary dictionary];
        resources[@"coins"] = @-1000;
        resources[@"gas"] = @-50;
        resources[@"bike_1"] = 1;
        [GW Converting:resources place:@"bank"]
```

You can also use the following methods:

``Consume`` - to buy items for game currency. For example:

```objc
    [GW ConsumeCurrency:@"coins" number:@1000 sink:@"gas" amount:@50 place:@"shop"];
```

``Acquire`` - for in-app purchases. It's important to call ``acquire`` method after ``InAppPurchased``. For example:

```objc
    [GW AcquireCurrency:@"coins: amount:@1000 source:sku number:@1 place:@"bank];
```



> You can find an example of using the SDK [here](https://github.com/Game-of-whales/GOW-SDK-IOS/tree/master/Example).

Run your app. The information about it began to be collected and displayed on the [dashboard](http://gameofwhales.com/documentation/dashboard). In a few days, you will get data for analyzing.

This article includes the documentation for _Game of Whales iOS Native SDK_. You can find information about other SDKs in [documentation about Game of Whales](http://www.gameofwhales.com/documentation/download-setup).



# FAQ
To fix the error
```
NSErrorFailingURLStringKey The resource could not be loaded because the App Transport Security policy
requires the use of a secure connection.
```
make the following settings in _info.plist_:

<img src=http://www.gameofwhales.com/sites/default/files/documentation/NSAppTransportSecurityError.png>
