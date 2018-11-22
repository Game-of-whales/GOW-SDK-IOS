//
//  ViewController.m
//  test_objc
//
//  Created by Denis Sachkov on 02.06.17.
//  Copyright © 2017 Deemedya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GWManager sharedManager] addDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[GWManager sharedManager] removeDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (void)purchasedReplacement:(nonnull GWReplacement *)replacement transaction:(nonnull SKPaymentTransaction *)transaction
{
    
}

- (void)appearedReplacement:(nonnull GWReplacement *)replacement
{
    
}

- (void)disappearedReplacement:(nonnull GWReplacement *)replacement
{
    
}



- (void)buy:(NSString *)productIdentifer
{
    GWReplacement *rep = [[GWManager sharedManager] replacementForProductIdentifier:productIdentifer];
    
    if (rep != NULL)
    {
        [rep productIdentifier];
    }
    else
    {
        productIdentifer;
    }
    
}

@end
