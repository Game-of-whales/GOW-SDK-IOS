# GOW-SDK-IOS

# Download

Download the latest sdk version from our server:

[<img src=https://www.gameofwhales.com/sites/default/files/documentation/download.png>](https://github.com/Game-of-whales/GOW-SDK-IOS/releases/download/v2.0.26/gameofwhales.zip)

# Changelog


### 2.0.26 (Jun 25, 2019)

ADDED
* GDPR support: the non-personal mode was added. 



### 2.0.24 (Jun 19, 2019)

ADDED

* `onInitialized` callback was added. It should be used to get information that the SDK has been initialized.
* `Purchase` method was added to register purchases without verification.


### 2.0.23 (Feb 15, 2019)

* Minor fixes.


### 2.0.22 (Jan 25, 2019)

ADDED

* The supporting of [future (anti-churn) special offers](https://www.gameofwhales.com/documentation/anti-churn-offers) were added.
* The possibility of getting a profile's properties was added.

FIXED

* The issue with getting server time on 32-bit devices was fixed.


### 2.0.21 (Dec 17, 2018)

FIXED

* The handling of errors was improved.
* The selection of advertising (cross-promotion) images depending on the orientation of the device was fixed.
* The repeating of cross-promotion ads after some minutes was fixed.


### 2.0.20 (Nov 20, 2018)

ADDED

* The supporting of cross promotion ads was added.


### 2.0.15 (Sep 25, 2018)

ADDED

* ``GetServerTime`` method was added to get GOW server time.
* Server time is used in special offers to check the time for the activation.



### 2.0.14 (Jun 14, 2018)

ADDED

* ```redeemable``` parameter was added to ```SpecialOffer``` class.


### 2.0.13 (May 14, 2018)

ADDED

* Custom data is supported for special offers.
* The information about a device's locale is sent to **Game of Whales**.


### 2.0.12 (Jan 11, 2018)

ADDED

* _getLeftTime_ method for special offers.

### 2.0.11 (Dec 15, 2017)

MODIFIED

* Push notification about special offer comes at the same time with the special offer (new parameter _offer_ was added):<br/>
``void onPushDelivered(SpecialOffer offer, String campID, String title, String message);``

* ``setPushNotificationsEnable`` method was added to allow user to turn off the push notifications.

* Added static methods instead of _shared_ methods.


### 2.0.10 (Nov 21, 2017)

FIXED
* _pushReacted_ sending with empty _camp_.


### 2.0.9 (Nov 13, 2017)

MODIFIED
* renamed "Reachability" class to "GWReachability".


### 2.0.8 (Oct 19, 2017)

FIXED
* bug with _pushDelivered_ and _pushReacted_ events for push campaigns.


### 2.0.7 (Oct 18, 2017)

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


Load ```GameOfWhalesBundle.bundle``` file to your project.

<img src=http://www.gameofwhales.com/sites/default/files/documentation/load_bundle_file.png>

Than add it to **Build Phase** -> **Copy Bundle Resources**.

<img src=http://www.gameofwhales.com/sites/default/files/documentation/add_bundle_file.png>


### Step 2
Add ```GWGameKey``` parameter to ```info.plist``` and specify your [game key](http://www.gameofwhales.com/documentation/game).
 
<img src=http://www.gameofwhales.com/sites/default/files/documentation/game_key.png>




## SWIFT

### Step 3

Subscribe to ```onInitialized``` if you want to get information that the SDK has been initialized.

```swift
func onInitialized() 
 {
 }
```

Call ```initialize``` method when you launch your app.

```swift
import GameOfWhales
...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
{
  ...
   Bool debugLog = false;
   GW.initialize( launchOptions, false);

```


>**GDPR NOTE:** By default, the SDK uses advertisement ID (IDFA) as a user ID to send events to **Game of Whales** server. In order to work in a non-personal mode when a random value will be used as a user ID, the SDK should be initialized as follows:

```swift
        let nonPersonal = true;
        let debugLog = true;
        GW.initialize(withGameKey: "YOU_GAME_KEY", launchOptions, debugLog, nonPersonal);
```
  
## Purchases

**Purchases with verification on GOW server side**

>Check that _iOS Bundle Identifier_ (for iOS app) has been filled on [*Game Settings*](https://www.gameofwhales.com/documentation/game#game-settings) page before you will make a purchase.

### Step 4 (only if you use in-app purchases)
Register a purchase with ``purchaseTransaction`` method.

```swift
 func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for t in transactions
       if t.transactionState == SKPaymentTransactionState.purchased
           GW.purchaseTransaction(t, product: product!);
```

**Purchase without verification on GOW server side**

>The method is available since v.2.0.24 SDK version.

In order to send information about purchases without verification on **Game of Whales** side, call ```purchase``` method. For example:

```swift
   let productID = "product_10";
   let currency = "USD";
   let price = 1.99;

   GW.purchase(productID, currency, price * 100);
```

>Pay attention that all purchases received through ```purchase``` method (including refunds, restores, cheater's purchases) will increase the stats. So in order to have correct stats, a game developer should verify purchases on the game side and send the data only about legal purchases to **Game of Whales** system.



## Special Offers

Before any product can be used in a special offer it has to be bought by someone after SDK has been implemented into the game. Please make sure your game has at least one purchase of the product that is going to be used in the special offer.
If you want to create a special offer for in game resource, please, make sure your game has at least one _converting_ event with the appropriate resource.


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
 
 func futureSpecialOfferAppeared(_ specialOffer: GWSpecialOffer) 
 {
 }
 
 func onPushDelivered(_ offer:GWSpecialOffer?, camp: String, title:String, message:String)
 {
 }
```

The verify state can be:

* _GW_VERIFY_STATE_LEGAL_ - a purchase is normal.
* _GW_VERIFY_STATE_ILLEGAL_ - a purchase is a cheater's.
* _GW_VERIFY_STATE_UNDEFINED_ - GOW server couldn't define the state of a purchase. 


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

It's possible to pass [custom data](https://www.gameofwhales.com/documentation/custom-data) to special offers. In order to get the data in game's side, use _customValues_ parameter of  _SpecialOffer_ class.

```swift
    let str = offer.customValues.valueForKey("your_string") as? NSTring
    let number = offer.customValues.valueForKey("your_number") as? NSNumber
    let boolean = offer.customValues.valueForKey("your_bool") as? NSNumber
```

## Notifications

### Step 8 (for iOS only)

Enable the _Push Notifications_ option in the _Xcode_.

<img src=http://www.gameofwhales.com/sites/default/files/documentation/iOS%20notification.png>

### Step 9

In order to send notifications from GOW server it is necessary to pass the token information to the server.

```swift
    //FIREBASE
    let token = FIRInstanceID.instanceID().token();
    GW.registerDeviceToken(with: token!, provider:GW_PROVIDER_FCM);
    
    //APN
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        GW.registerDeviceToken(with: deviceToken, provider: GW_PROVIDER_APN)
```

### Step 10

To get information about a player's reaction on notifications add the following methods to ```AppDelegate```:

```swift
func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
                     {
                     
                     GWManager.receivedRemoteNotification(userInfo, with: application, fetchCompletionHandler: completionHandler);
                     
                     }
```

### Step 11 (Only if notifications are shown inside your app by using the game's code)

In order to send the information to _Game of Whales_ regarding a player's reaction on a notification (to increase push campaign's _Reacted_ field) of an already started app call the following method:

```swift
      func onPushDelivered(_ offer:GWSpecialOffer?, camp: String, title:String, message:String) {
            //Show message and call:
            GW.reactedRemoteNotification(withCampaign: camp);
```

### Step 12

In order to enable or disable push notifications, use the following method:

```swift
   GW.setPushNotificationsEnable(false);
```

In order to check notifications implementation send [a test notification](http://www.gameofwhales.com/documentation/how-send-test-push-notification).

## Profiles

### Step 13

You can send additional data about your players by using the ``profile`` method. ``profile`` method should be called if key parameters of your app or a player have changed.

>In order to work with AI offers you should send at least 5 number-type properties and at least one progress based parameter.

>If you send more than 3000 properties, **Game of Whales** will sort all properties alphabetically and will save only the first 3000.

>If the length of a string-type property is more than 64 characters, **Game of Whales** will save only the first 64 characters.


For example:
```swift
    GW.profile(["coins":1000, "class":"wizard", "gender":true, "locatiom":"A"]);
 ```

## Converting

### Step 14

If you are going to use [AI offers](https://www.gameofwhales.com/documentation/ai-offers) functionality you need to send to **Game of Whales** information about players' game activity by using ``сonverting`` method. ``сonverting`` method should be called to show what exactly the player spent and what he got instead of spent resources. [Read more...](https://www.gameofwhales.com/documentation/ai-offers#aiData)


For example:
Someone bought one _bike_1_ for _1000_ coins and _50_ gas. You should call the following method to reflect this operation in **Game of Whales**:


```swift
      GW.converting(["coins":-1000, "gas":-50, "bike_1":1], place: "bank")
```

Another sample: someone bought a main pack for $5. It was in-app purchase with _mainPack_ SKU. The pack included _100 coins_ and _1 bike_. In order to send the data that the player got _100 coins_ and _1 bike_ after the purchase of _mainPack_ to **Game of Whales**, the following ``сonverting`` method should be called:


```swift
      GW.converting(["bike": 1, "coin": 100, "mainPack": -1], place: "shop")
```


There are 2 additional methods that can be used instead of ```converting``` method:

``consume`` - to show that a player spends a certain amount of one resource for the purchase of a quantity of another resource.

For example:

```swift
    GW.consumeCurrency("coins", number:1000, sink:"gas", amount:50, place:"shop")
```
It means that someone spent 1000 "coins" for 50 "gas" in "shop".


``acquire`` -  to show that a player acquires a certain amount of one resource and spends a quantity of another resource. The method can be used for _in-app_ and _in game_ items. It's important to call ``acquire`` method after ``InAppPurchased``.

```swift
    GW.acquireCurrency("coins", amount:1000, source:sku, number:1, place:"bank")
```
It means that someone has acquired 1000 "coins" for 1 "sku" in "bank".

``consume`` and ``acquire`` methods can be called when one resource is changed to another resource. In more complicated cases (for example, when one resource is spent for several types of resources) ``converting`` method should be called.



## Cross promotion ads

> It's supported since version 2.0.20 of SDK for iOS.

To handle the ads set in **Game of Whales**, you need to do some actions:

### Step 15

Subscribe to the following events to get the information about the current state of the ads by using ``GWDelegate`` (the same as you do it on _Step 6_): 

```swift
func onAdLoaded() 
 {
 }
    
 func onAdLoadFailed() 
 {
 }
    
 func onAdClosed() 
 {
 }
```

### Step 16

Start to load the ads at any place of your code (for example, during the launch of the game):

```swift
  GW.loadAd()
```

### Step 17

Add the following code to the part of your game where you want to show the ads:

```swift
if (GW.isAdLoaded())
    GW.showAd()
else
    GW.loadAd()
```

## Profile's properties

### Step 18

You can get some profile's properties defined on **Game of Whales** side via the SDK.

For example, you can get the profile's property `group` by using the following code:

```swift
let properties = GW.getProperties()
if (properties["group"] != nil)
    {
        let group = properties.objectForKey("group")
    }
```

You can also receive the profile's group by using the special method:

```swift
   let group = GW.getUserGroup()
```



# Objective-C

### Step 3

Subscribe to ```onInitialized``` if you want to get information that the SDK has been initialized.

```objective-c
- (void)onInitialized
{

}
```

Call ```initialize``` method when you launch your app.

```objective-c
#import <GameOfWhales/GameOfWhales.h>
...
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...
    BOOL debugLog = false;
    [GW initialize:launchOptions :debugLog];
```

> **GDPR NOTE:** By default, the SDK uses advertisement ID (IDFA) as a user ID to send events to **Game of Whales** server. In order to work in a non-personal mode when a random value will be used as a user ID, the SDK should be initialized as follows:

```objc
    BOOL nonPersonal = TRUE;
    BOOL debugLog = TRUE;
    [GW Initialize:launchOptions :debugLog :nonPersonal];
```

## Purchases

**Purchase with verification on GOW server side**

>Check that _iOS Bundle Identifier_ (for iOS app) has been filled on [*Game Settings*](https://www.gameofwhales.com/documentation/game#game-settings) page before you will make a purchase.

### Step 4 (only if you use in-app purchases)
Register a purchase with ``purchaseTransaction`` method.

```objective-c
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
     for(SKPaymentTransaction * t in transactions)
         if (t.transactionState == SKPaymentTransactionStatePurchased)
                 [GW PurchaseTransaction:t product:product];
}
```

**Purchase without verification on GOW server side**

>The method is available since v.2.0.24 SDK version.

In order to send information about purchases without verification on **Game of Whales** side, call ```Purchase``` method. For example:

```objective-c
   NSString *product = @"product_10";
   NSString *currency = @"USD";
   double price = 1.99;
    
   [GW Purchase:product :currency :price];
```

>Pay attention that all purchases received through ```Purchase``` method (including refunds, restores, cheater's purchases) will increase the stats. So in order to have correct stats, a game developer should verify purchases on the game side and send the data only about legal purchases to **Game of Whales** system.



## Special Offers

Before any product can be used in a special offer it has to be bought by someone after SDK has been implemented into the game. Please make sure your game has at least one purchase of the product that is going to be used in the special offer.
If you want to create a special offer for in game resource, please, make sure your game has at least one _converting_ event with the appropriate resource.

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

- (void)futureSpecialOfferAppeared:(nonnull GWSpecialOffer *)specialOffer
{

}

- (void)onPushDelivered:(nullable GWSpecialOffer*) offer camp:(nonnull NSString *)camp title:(nonnull NSString*)title message:(nonnull NSString*)message
{
    
}

- (void)onPurchaseVerified:(nonnull NSString*)transactionID state:(nonnull NSString*)state
{
    
}
```

The verify state can be:

* _GW_VERIFY_STATE_LEGAL_ - a purchase is normal.
* _GW_VERIFY_STATE_ILLEGAL_ - a purchase is a cheater's.
* _GW_VERIFY_STATE_UNDEFINED_ - GOW server couldn't define the state of a purchase. 


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
 
 It's possible to pass [custom data](https://www.gameofwhales.com/documentation/custom-data) to special offers. In order to get the data in game's side, use _customValues_ parameter of  _SpecialOffer_ class.
 
```objective-c
   NSString * str = [specialOffer.customValues objectForKey:@"your_str"];
   NSNumber * number = [specialOffer.customValues objectForKey:@"your_int"];
   NSNumber * boolean = [specialOffer.customValues objectForKey:@"your_bool"];
```
 
## Notifications

### Step 8 (for iOS only)

Enable the _Push Notifications_ option in the _Xcode_.

<img src=http://www.gameofwhales.com/sites/default/files/documentation/iOS%20notification.png>

### Step 9

In order to send notifications from GOW server it is necessary to pass the token information to the server.

```objective-c
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 
    //FIREBASE
    [GW RegisterDeviceTokenWithString:[[FIRInstanceID instanceID] token] provider:GW_PROVIDER_FCM];
    
    //APN
    [GW RegisterDeviceTokenWithData:deviceToken provider:GW_PROVIDER_APN];
}
```

### Step 10
To get information about a player's reaction on notifications add the following methods to ```AppDelegate```:

```objective-c
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
   {
     [GW ReceivedRemoteNotification:userInfo withApplication:application fetchCompletionHandler:completionHandler]; 
   }
 ```

### Step 11 (Only if notifications are shown inside your app by using the game's code)
In order to send the information to *Game of Whales* regarding a player's reaction on a notification (to increase push campaign's Reacted field) of an already started app call the following method:

```objective-c
- (void)onPushDelivered:(nullable GWSpecialOffer*) offer camp:(nonnull NSString *)camp title:(nonnull NSString*)title message:(nonnull NSString*)message
{
    //Show the notification to a player and then call the following method
    [GW ReactedRemoteNotificationWithCampaign:camp];
}
```

### Step 12

In order to enable or disable push notifications, use the following method:

```objective-c
  [GW SetPushNotificationsEnable:false];
```

In order to check notifications implementation send [a test notification](http://www.gameofwhales.com/documentation/how-send-test-push-notification).


## Profiles

### Step 13

You can send additional data about your players by using the ``Profile`` method. ``Profile`` method should be called if key parameters of your app or a player have changed.

>>In order to work with AI offers you should send at least 5 number-type properties and at least one progress based parameter.

>If you send more than 3000 properties, **Game of Whales** will sort all properties alphabetically and will save only the first 3000.

>If the length of a string-type property is more than 64 characters, **Game of Whales** will save only the first 64 characters.
 
 For example:
 
 ```objc
     NSMutableDictionary *changes = [NSMutableDictionary dictionary];
     changes[@"coins"] = @1000;
     changes[@"class"] = @"wizard";
     changes[@"gender"] = @TRUE;
     changes[@"location"] = @"A";
     [GW Profile:changes];
 ```

## Converting

### Step 14

If you are going to use [AI offers](https://www.gameofwhales.com/documentation/ai-offers) functionality you need to send to **Game of Whales** information about players' game activity by using ``Converting`` method. ``Converting`` method should be called to show what exactly the player spent and what he got instead of spent resources. [Read more...](https://www.gameofwhales.com/documentation/ai-offers#aiData)


For example:

Someone bought one _bike_1_ for _1000_ coins and _50_ gas. You should call the following method to reflect this operation in **Game of Whales**:

```objc
        NSMutableDictionary *resources = [NSMutableDictionary dictionary];
        resources[@"coins"] = @-1000;
        resources[@"gas"] = @-50;
        resources[@"bike_1"] = 1;
        [GW Converting:resources place:@"bank"]
```

Another sample: someone bought a main pack for $5. It was in-app purchase with _mainPack_ SKU. The pack included _100 coins_ and _1 bike_. In order to send the data that the player got _100 coins_ and _1 bike_ after the purchase of _mainPack_ to **Game of Whales**, the following ``Converting`` method should be called:

```objc
        NSMutableDictionary *resources = [NSMutableDictionary dictionary];
        resources[@"coin"] = 100;
        resources[@"bike"] = 1;
        resources[@"mainPack"] = @-1;
        [GW Converting:resources place:@"shop"]
```



There are 2 additional methods that can be used instead of ```Converting``` method:

``Consume`` - to show that a player spends a certain amount of one resource for the purchase of a quantity of another resource.

For example:

```objc
    [GW ConsumeCurrency:@"coins" number:@1000 sink:@"gas" amount:@50 place:@"shop"];
```
It means that someone spent 1000 "coins" for 50 "gas" in "shop".



``Acquire`` -  to show that a player acquires a certain amount of one resource and spends a quantity of another resource. The method can be used for _in-app_ and _in game_ items. It's important to call ``Acquire`` method after ``InAppPurchased``.

For example:

```objc
    [GW AcquireCurrency:@"coins: amount:@1000 source:sku number:@1 place:@"bank];
```
It means that someone has acquired 1000 "coins" for 1 "sku" in "bank".

``Consume`` and ``Acquire`` methods can be called when one resource is changed to another resource. In more complicated cases (for example, when one resource is spent for several types of resources) ``Converting`` method should be called.


## Cross promotion ads

> It's supported since version 2.0.20 of SDK for iOS.

To handle the ads set in **Game of Whales**, you need to do some actions:

### Step 15

Subscribe to the following events to get the information about the current state of the ads by using ``GWDelegate`` (the same as you do it on _Step 6_): 

```objc
- (void)onAdLoaded
{

}

- (void)onAdLoadFailed
{

}

- (void)onAdClosed
{

}
```

### Step 16

Start to load the ads at any place of your code (for example, during the launch of the game):

```objc
  [GW LoadAd];
```

### Step 17

Add the following code to the part of your game where you want to show the ads:

```objc
if ([GW IsAdLoaded])
        [GW ShowAd];
else
        [GW LoadAd];
```


## Profile's properties

### Step 18

You can get some profile's properties defined on **Game of Whales** side via the SDK.

For example, you can get the profile's property `group` by using the following code:

```objc
NSMutableDictionary * properties = [GW getProperties];
if (properties[@"group"])
    {
        NSString* group = properties[@"group"];
    }
```

You can also receive the profile's group by using the special method:

```objc
   NSString * group = [GW GetUserGroup];
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
