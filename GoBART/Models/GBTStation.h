//
//  GBTStation.h
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GBTStation : NSObject

@property (assign, nonatomic) CLLocationCoordinate2D mapLocation;
@property (strong, nonatomic) NSString *stationFullName;
@property (strong, nonatomic) NSString *stationAbbreviatedName;

@end
