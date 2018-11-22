//
//  ViewController.h
//  test_objc
//
//  Created by Denis Sachkov on 02.06.17.
//  Copyright © 2017 Deemedya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gow/gow.h"

@interface ViewController : UIViewController<GWManagerDelegate>

- (void)appearedReplacement:(nonnull GWReplacement *)replacement;

- (void)disappearedReplacement:(nonnull GWReplacement *)replacement;

- (void)buy:(NSString *)productIdentifer;
@end

