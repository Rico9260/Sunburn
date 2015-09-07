//
//  UserLocation.m
//  Sunburn
//
//  Created by Aseem on 04/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "UserLocation.h"

static dispatch_once_t onceToken;
static UserLocation * sharedUserLocation= nil;
@implementation UserLocation

+(id)sharedSunburnUserLocation{
    
    dispatch_once(&onceToken,^{
        
        sharedUserLocation = [[self alloc] init];
    });
    
    return sharedUserLocation;
}

-(id)init{
    
    if (self == [super init]) {
        
        _locationManager = [CLLocationManager new];
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            
            [self.locationManager requestAlwaysAuthorization];
        }
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.delegate = self;
            [_locationManager startUpdatingLocation];
    }
    return self;
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    _locationServiceAvailable = NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    _locationServiceAvailable = YES;
    CLLocation * currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        
        [self reverseGeocodeUserLocation:currentLocation];
        _latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        _longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
        _arrLatLong = [NSMutableArray new];
        [_arrLatLong addObject:_latitude];
        [_arrLatLong addObject:_longitude];
    }
}

#pragma mark - Reverse Geocoding of location
-(void)reverseGeocodeUserLocation:(CLLocation *)location{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if (location)
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (error == nil && [placemarks count] > 0) {
                
                CLPlacemark * placemark = [placemarks objectAtIndex:0];
                
                _place = [NSString stringWithFormat:@"%@, %@",placemark.locality,placemark.country];
            }
            else {
                
                NSLog(@"%@", error.debugDescription);
            }
        }];
}

@end
