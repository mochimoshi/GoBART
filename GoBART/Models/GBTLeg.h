//
//  GBTLeg.h
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBTLeg : NSObject

@property (strong, nonatomic) NSString *line;
@property (strong, nonatomic) NSString *origTimeMin;
@property (strong, nonatomic) NSString *origTimeDate;
@property (strong, nonatomic) NSString *destTimeMin;
@property (strong, nonatomic) NSString *destTimeDate;
@property (strong, nonatomic) NSString *departStation;
@property (strong, nonatomic) NSString *arriveStation;

- (instancetype)initLegWithAttributes:(NSDictionary *)attributeDict;

@end
