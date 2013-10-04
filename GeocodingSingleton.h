//
//  Geocoding Singleton.h
//  P2O
//
//  Created by Chandler De Angelis on 7/4/13.
//  Copyright (c) 2013 Chandler De Angelis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class MapPoint;

@interface GeocodingSingleton : NSObject

@property (strong, nonatomic) NSMutableArray *geocoderQueue;
@property BOOL isOperationRunning;

+ (GeocodingSingleton *)sharedGeocoder;
- (void)performOperations;

@end
