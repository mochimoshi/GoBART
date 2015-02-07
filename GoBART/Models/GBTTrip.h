//
//  GBTTrip.h
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBTTrip : NSObject

@property (strong, nonatomic) NSString *tripDepartTime;
@property (strong, nonatomic) NSString *tripDepartStation;
@property (strong, nonatomic) NSString *tripArrivalTime;
@property (strong, nonatomic) NSString *tripArrivalStation;

@end
