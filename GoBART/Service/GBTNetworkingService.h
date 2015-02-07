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

@interface GBTNetworkingService : NSObject<NSXMLParserDelegate>

+ (instancetype)sharedNetworkingService;

- (void)getRoutesWithOrig:(NSString *)orig atDest:(NSString *)dest atTime:(NSDate *)date withCommand:(NSString *)command {


@end
