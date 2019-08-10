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

#import <UIKit/UIKit.h>
#import <GameOfWhales/GameOfWhales.h>

@interface ViewController : UIViewController<GWDelegate>

- (void)buy:(NSString *)productIdentifer;
@end


