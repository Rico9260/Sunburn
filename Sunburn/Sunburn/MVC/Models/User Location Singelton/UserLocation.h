//
//  UserLocation.h
//  Sunburn
//
//  Created by Aseem on 04/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserLocation : NSObject<CLLocationManagerDelegate>

@property CLLocationManager * locationManager;
@property NSString * latitude;
@property NSString * longitude;
@property NSString * place;
@property BOOL locationServiceAvailable;
@property NSMutableArray * arrLatLong;

+(id)sharedSunburnUserLocation;
@end
