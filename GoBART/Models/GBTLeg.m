//
//  GBTLeg.m
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import "GBTLeg.h"

@implementation GBTLeg

- (instancetype)initLegWithAttributes:(NSDictionary *)attributeDict {
    self = [super init];
    if (self) {
        self.line = attributeDict[@"line"];
        self.origTimeMin = attributeDict[@"origTimeMin"];
        self.origTimeDate = attributeDict[@"origTimeDate"];
        self.destTimeMin = attributeDict[@"destTimeMin"];
        self.destTimeDate = attributeDict[@"destTimeDate"];
        self.departStation = attributeDict[@"departStation"];
        self.arriveStation = attributeDict[@"departStation"];
    }
    return self;
}

@end
