//
//  Geocoding Singleton.m
//  P2O
//
//  Created by Chandler De Angelis on 7/4/13.
//  Copyright (c) 2013 Chandler De Angelis. All rights reserved.
//

#import "GeocodingSingleton.h"
#import "MapPoint.h"

@interface GeocodingSingleton ()
@property (strong, nonatomic) CLGeocoder *geocoder;
@end

@implementation GeocodingSingleton
//create one object
+ (GeocodingSingleton *)sharedGeocoder
{
    static GeocodingSingleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[GeocodingSingleton alloc] init];
    });
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _geocoderQueue = [[NSMutableArray alloc]  init];
        _geocoder = [[CLGeocoder alloc] init];
        _isOperationRunning = NO;
    }
    return self;
}

- (void)performOperations
{
    self.isOperationRunning = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    for (MapPoint *mp in self.geocoderQueue)
    {
        //create a location that can be geocoded
        CLLocation *location = [[CLLocation alloc]initWithCoordinate:mp.coordinate
                                                            altitude:CLLocationDistanceMax
                                                  horizontalAccuracy:kCLLocationAccuracyBest
                                                    verticalAccuracy:kCLLocationAccuracyBest
                                                           timestamp:[NSDate date]];
        
        [self.geocoder reverseGeocodeLocation:location
                            completionHandler:^(NSArray *placemarks, NSError *error) {
                                if (error)
                                {
                                    NSLog(@"Geocoder failed with error: %@", error);
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kGeocodeAdressFailed object:self userInfo:@{GeocodeFailedPin: mp, @"error": error}];
                                }
                                else
                                {
                                    //create a placemark, and do whatever you want with the address
                                    CLPlacemark *place = [placemarks objectAtIndex:0];
                                    NSString *geocodedAddress = [NSString stringWithFormat:@"%@ %@, %@, %@", [place subThoroughfare], [place thoroughfare], [place locality], [place administrativeArea]];
                                    mp.title = titleAddress;
                                    
                                    [self.geocoderQueue removeObject:mp];
                                }
                            }];
    }
    self.isOperationRunning = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
