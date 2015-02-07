//
//  ViewController.m
//  GoBART
//
//  Created by Alex Yuh-Rern Wang on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import "GBTHomeViewController.h"
#import "GBTNetworkingService.h"
@interface GBTHomeViewController ()

@end

@implementation GBTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GBTNetworkingService *sharedService = [GBTNetworkingService sharedNetworkingService];
    NSDate *date = [NSDate date];
    NSString *command = @"arrive";
    [sharedService getRoutesWithOrig:@"ASHB" atDest:@"CIVC" atTime:date withCommand:command];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
