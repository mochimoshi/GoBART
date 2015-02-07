//
//  GBTNetworkingService.h
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RouteSuccessBlock)(id responseObject);
typedef void (^RouteFailureBlock)(NSError *error);

@interface GBTNetworkingService : NSObject

+ (instancetype)sharedNetworkingService;

- (void)getRoutesWithOrig:(NSString *)orig dest:(NSString *)dest;

@end
