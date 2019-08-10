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

#import "ViewController.h"

@interface ViewController ()

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    [GW AddDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [GW RemoveDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)buy:(NSString *)productIdentifer
{
//    GWReplacement *rep = [[GWManager sharedManager] replacementForProductIdentifier:productIdentifer];
//    
//    if (rep != NULL)
//    {
//        [rep productIdentifier];
//    }
//    else
//    {
//        productIdentifer;
//    }
//    
}

- (void)onPushDelivered:(nullable GWSpecialOffer*) offer camp:(nonnull NSString *)camp title:(nonnull NSString*)title message:(nonnull NSString*)message
{
    
}

- (void)specialOffer:(GWSpecialOffer *)specialOffer appearedFor:(NSString *)productIdentifier {

}

- (void)specialOffer:(GWSpecialOffer *)specialOffer disappearedFor:(NSString *)productIdentifier {

}

- (void)specialOffersUpdated {

}


@end
