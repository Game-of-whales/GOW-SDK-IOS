# GOW-SDK-IOS

# Download

Download the latest sdk version from our server:

[<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/download.png>]()

 

# Implementation Guide

* [Common](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#common)
* [For SWIFT](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#swift)
* [For Objective-С](https://github.com/Game-of-whales/GOW-SDK-IOS/blob/master/README.md#objective-c)


## Common

### Step 1

Add ```GameOfWhales.framework``` to ```Linked Frameworks and Libraries``` XCODE section of your project. 

<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/add_framework.png>

### Step 2
Add ```GWGameKey``` parameter to ```info.plist``` and specify your [game key](http://www.gameofwhales.com/#/documentation/game).
 
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
 GWManager.shared().launch(options: launchOptions)
```

## Special Offers

### Step 4

If you want to use [special offers](http://www.gameofwhales.com/#/documentation/so), you need to implement some methods of ```GWManagerDelegate``` protocol and call ```add``` method.

```swift
class ViewController: UIViewController, GWManagerDelegate
...
     override func viewDidLoad() {
        super.viewDidLoad()
        
        GWManager.shared().add(self)
...
   
   
     override func viewDidDisappear(_ animated: Bool) {
     
        //remove self from delegates
        GWManager.shared().remove(self)

```

### Step 5
Add the following methods:

```swift
 func purchasedReplacement(_ replacement: GWReplacement, transaction: SKPaymentTransaction) 
 {
 }
 
 func appearedReplacement(_ replacement: GWReplacement) 
 {
 }
 
 func disappearedReplacement(_ replacement: GWReplacement) 
 {
 }
```

### Step 6

In order to get the current _Replacement_ during a purchase you can use the following code: 

```swift
    let rep = GWManager.shared().replacement(forProductIdentifier: productIdentifier);
    if (rep != nil){
        //buy replacement: rep!.product
    } else {
        //buy regular: productIdentifier
    }
```

## Notifications

### Step 7

In order to notification sending by server  it's necessary to send information about token to it. 

```swift
    let token = FIRInstanceID.instanceID().token();
    GWManager.shared().updateDeviceToken(token);
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
    [[GWManager sharedManager] launchWithOptions:launchOptions];
```

## Special Offers

### Step 4

If you want to use [special offers](http://www.gameofwhales.com/#/documentation/so), you need to implement some methods of ```GWManagerDelegate``` protocol and call ```addDelegate``` method.

```objective-c
@interface ViewController : UIViewController<GWManagerDelegate>
...
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GWManager sharedManager] addDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[GWManager sharedManager] removeDelegate:self];
}

```

### Step 5
Add the following methods:

```objective-c
- (void)purchasedReplacement:(nonnull GWReplacement *)replacement transaction:(nonnull SKPaymentTransaction *)transaction
{   
}

- (void)appearedReplacement:(nonnull GWReplacement *)replacement
{  
}

- (void)disappearedReplacement:(nonnull GWReplacement *)replacement
{   
}
```

### Step 6

In order to get the current _Replacement_ during a purchase you can use the following code: 

```objective-c
 GWReplacement *rep = [[GWManager sharedManager] replacementForProductIdentifier:productIdentifer];
   if (rep != NULL)
   {
     //buy replacement: [rep productIdentifier]
   }
   else
   {
     //buy original product: productIdentifer
   }
 ```

## Notifications

### Step 7

In order to [notifications](http://www.gameofwhales.com/#/documentation/push) sending by server  it's necessary to send information about token to it. 

```objective-c
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[GWManager sharedManager] updateDeviceTokenForNSData:deviceToken];
}
```

### Step 8
To get information about a player's reaction on notifications add the following methods to ```AppDelegate```:

```objective-c
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
   {
     [[GWManager sharedManager] receivedRemoteNotification:userInfo withApplication:application fetchCompletionHandler:completionHandler]; 
   }
 ```

### Step 9 (Only if notifications are shown inside your app by using the game's code)
In order to send the information to *Game of Whales* regarding a player's reaction on a notification (to increase push campaign's Reacted field) of an already started app call the following method:

```objective-c
     [[GWManager sharedManager] pushReacted:pushID];
```

You can get _pushID_ like this:

```objective-c
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
                     
                     NSString * pushID = [[GWManager sharedManager] getPushID:userInfo];
                     ... //Show message and than call pushReacted
```


> You can find an example of using the SDK [here]().

Run your app. The information about it began to be collected and displayed on the [dashboard](http://gameofwhales.com/#/documentation/dashboard). In a few days, you will get data for analyzing.

This article includes the documentation for _Game of Whales iOS Native SDK_. You can find information about other SDKs in [documentation about Game of Whales](http://www.gameofwhales.com/#/documentation).
