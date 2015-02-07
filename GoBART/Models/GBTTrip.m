//
//  GBTTrip.m
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import "GBTTrip.h"

@implementation GBTTrip

- (instancetype)initTripWithAttributes:(NSDictionary *)attributeDict {
    self = [super init];
    if (self) {
        self.tripDepartTime = attributeDict[@"origTimeMin"];
        self.tripArrivalStation = attributeDict[@"destTimeMin"];
        self.tripDepartStation = attributeDict[@"origin"];
        self.tripArrivalStation = attributeDict[@"destination"];
        self.tripLegsArray = [NSMutableArray array];
        self.tripFare = attributeDict[@"fare"];
        //NSLog(@"%@", self.tripDepartStation);
    }
    return self;
}

@end
