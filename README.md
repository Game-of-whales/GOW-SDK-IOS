# GOW-SDK-IOS

# Download

Download the latest sdk version from our server:

[<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/download.png>](https://github.com/Game-of-whales/GOW-SDK-IOS/archive/v2.0.6.zip)

 

# Implementation Guide

* [Common](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#common)
* [For SWIFT](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#swift)
* [For Objective-С](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#objective-c)
* [FAQ](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#faq)



## Common

### Step 1

Add ```GameOfWhales.framework``` to ```Linked Frameworks and Libraries``` XCODE section of your project. 

<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/add_framework.png>

### Step 2
Add ```GWGameKey``` parameter to ```info.plist``` and specify your [game key](http://www.gameofwhales.com/documentation/game).
 
<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/game_key.png>




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


### Step 4

If you want to use [special offers](http://www.gameofwhales.com/documentation/special-offers), you need to implement some methods of ```GWManagerDelegate``` protocol and call ```add``` method.

```swift
class ViewController: UIViewController, GWDelegate     
...

     override func viewWillAppear(_ animated: Bool) {
         GWManager.shared().add(self)
     }
   
     override func viewDidDisappear(_ animated: Bool) {
     
        //remove self from delegates
        GWManager.shared().remove(self)

```

### Step 5
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
 
 func onPushDelivered(_ camp: String, title:String, message:String)
 {
 }
```

### Step 6 Special Offers
In order to receive a special offer call the following method:

```swift
   let offer = GW.shared().getSpecialOffer(productIdentifier);
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

### Step 7

in order to send notifications from GOW server it is necessary to pass the token information to the server.

```swift
    let token = FIRInstanceID.instanceID().token();
    GW.shared().registerDeviceToken(with: token!, provider:GW_PROVIDER_FCM);
```

### Step 8

To get information about a player's reaction on notifications add the following methods to ```AppDelegate```:

```swift
func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
                     {
                     
                     GWManager.shared().receivedRemoteNotification(userInfo, with: application, fetchCompletionHandler: completionHandler);
                     
                     }
```

### Step 9 (Only if notifications are shown inside your app by using the game's code)

In order to send the information to _Game of Whales_ regarding a player's reaction on a notification (to increase push campaign's _Reacted_ field) of an already started app call the following method:

```swift
      GWManager.shared().pushReacted(pushID);
```

You can get _pushID_ like this:

```swift
func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
                     
                     let pushID = GWManager.shared().getPushID(userInfo);
                     ... //Show message and than call pushReacted
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

### Step 4

If you want to use [special offers](http://www.gameofwhales.com/documentation/special-offers), you need to implement some methods of ```GWManagerDelegate``` protocol and call ```addDelegate``` method.

```objective-c
@interface ViewController : UIViewController<GWManagerDelegate>
...
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GW shared] addDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[GW shared] addDelegate:self];
}

```

### Step 5
Add the following methods:

```objective-c
- (void)specialOfferAppeared:(nonnull GWSpecialOffer *)specialOffer
{
    
}

- (void)specialOfferDisappeared:(nonnull GWSpecialOffer *)specialOffer
{
    
}

- (void)onPushDelivered:(nonnull NSString *)camp title:(nonnull NSString*)title message:(nonnull NSString*)message
{
    
}

- (void)onPurchaseVerified:(nonnull NSString*)transactionID state:(nonnull NSString*)state
{
    
}
```

### Step 6  Special Offers

In order to receive a special offer call the following method: 

```objective-c
    GWSpecialOffer* so = [[GW shared] getSpecialOffer:productIdentifer];
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

### Step 7

In order to [notifications](http://www.gameofwhales.com/documentation/push-notifications) sending by server  it's necessary to send information about token to it. 

```objective-c
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 
    //FIREBASE
    [[GW shared] registerDeviceTokenWithString:[[FIRInstanceID instanceID] token] provider:GW_PROVIDER_FCM];
    
    //APN
    [[GW shared] registerDeviceTokenWithData:deviceToken provider:GW_PROVIDER_APN];
}
```

### Step 8
To get information about a player's reaction on notifications add the following methods to ```AppDelegate```:

```objective-c
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
   {
     [[GW shared] receivedRemoteNotification:userInfo withApplication:application fetchCompletionHandler:completionHandler]; 
   }
 ```

### Step 9 (Only if notifications are shown inside your app by using the game's code)
In order to send the information to *Game of Whales* regarding a player's reaction on a notification (to increase push campaign's Reacted field) of an already started app call the following method:

```objective-c
- (void)onPushDelivered:(nonnull NSString *)camp title:(nonnull NSString*)title message:(nonnull NSString*)message
{
    //Show the notification to a player and then call the following method
    [[GW shared] reactedRemoteNotificationWithCampaign:camp];
}
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

<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/NSAppTransportSecurityError.png>
