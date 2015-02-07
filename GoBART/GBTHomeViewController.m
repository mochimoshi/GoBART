//
//  ViewController.m
//  GoBART
//
//  Created by Alex Yuh-Rern Wang on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import "GBTHomeViewController.h"

#import "GBTNetworkingService.h"

@interface GBTHomeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *destTextField;

@end

@implementation GBTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fromTextField setText:@"FRMT"];
    [self.destTextField setText:@"16TH"];
}

- (IBAction)route:(id)sender {
    [self resignFirstResponder];
    GBTNetworkingService *sharedService = [GBTNetworkingService sharedNetworkingService];
    [sharedService getRoutesWithOrig:self.fromTextField.text
                              atDest:self.destTextField.text
                              atTime:[NSDate date]
                         withCommand:@"arrive"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
