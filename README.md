# GOW-SDK-IOS

# Download

Download the latest sdk version from our server:

[<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/download.png>]()

 

# Implementation Guide

* [Common](https://github.com/Game-of-whales/GOW-SDK-IOS/edit/master/README.md#common)
* [For SWIFT](https://github.com/Game-of-whales/GOW-SDK-IOS/edit/master/README.md#swift)
* [For Objective-c](https://github.com/Game-of-whales/GOW-SDK-IOS/edit/master/README.md#objective-c)
* [FAQ](https://https://github.com/Game-of-whales/GOW-SDK-IOS/edit/master/README.md#faq)


## Common

### Step 1

Add ```gow.framework``` to ```Embedded Binaries``` XCODE section of your project. 

<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/add_framework.png>

### Step 2
Add ```GWGameKey``` parameter to ```info.plist``` and specify your [game key](http://www.gameofwhales.com/#/documentation/game).
 
<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/game_key.png>




## SWIFT

### Step 3
Call a method ```launchWithOptions``` when you launch your app.

```swift
import gow
...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
{
 ...
 GWManager.shared().launch(options: launchOptions)
```

## Special Offers

### Step 4

If you want to use [special offers](http://www.gameofwhales.com/#/documentation/so), you need to implement some methods of ```GWManagerDelegate``` protocol and call ```GWManager.shared().add``` method.

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
#import "gow/gow.h"
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


# FAQ
### How to exclude _i386_, _x86_64_ from your project?

In order to exclude _i386_, _x86_64_ from your project when you are building project in *AppStore*, add the following script:

```bash

echo "Target architectures: $ARCHS"

APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"
echo $(lipo -info $FRAMEWORK_EXECUTABLE_PATH)

FRAMEWORK_TMP_PATH="$FRAMEWORK_EXECUTABLE_PATH-tmp"

# remove simulator's archs if location is not simulator's directory
case "${TARGET_BUILD_DIR}" in
*"iphonesimulator")
echo "No need to remove archs"
;;
*)
if $(lipo $FRAMEWORK_EXECUTABLE_PATH -verify_arch "i386") ; then
lipo -output $FRAMEWORK_TMP_PATH -remove "i386" $FRAMEWORK_EXECUTABLE_PATH
echo "i386 architecture removed"
rm $FRAMEWORK_EXECUTABLE_PATH
mv $FRAMEWORK_TMP_PATH $FRAMEWORK_EXECUTABLE_PATH
fi
if $(lipo $FRAMEWORK_EXECUTABLE_PATH -verify_arch "x86_64") ; then
lipo -output $FRAMEWORK_TMP_PATH -remove "x86_64" $FRAMEWORK_EXECUTABLE_PATH
echo "x86_64 architecture removed"
rm $FRAMEWORK_EXECUTABLE_PATH
mv $FRAMEWORK_TMP_PATH $FRAMEWORK_EXECUTABLE_PATH
fi
;;
esac

done
``` 

<img src=https://github.com/Game-of-whales/GOW-SDK-IOS/wiki/img/remove_arch.png>
