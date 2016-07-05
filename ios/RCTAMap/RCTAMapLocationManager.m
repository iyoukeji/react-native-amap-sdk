//
// Created by 刘思贤 on 16/7/1.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import "RCTEventDispatcher.h"
#import "RCTAMapLocationManager.h"


@implementation RCTAMapLocationManager
{
    AMapLocationManager *_locationManager;
}

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [AMapLocationManager new];
        _locationManager.delegate = self;
    }

    return self;
}

RCT_EXPORT_METHOD(startUpdatingLocation:
(BOOL) background)
{
    if (background) {
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            [_locationManager setAllowsBackgroundLocationUpdates:YES];
        }
    }
    [_locationManager startUpdatingLocation];
}

RCT_EXPORT_METHOD(stopUpdatingLocation)
{
    [_locationManager stopUpdatingLocation];
}

RCT_EXPORT_METHOD(requestCurrentLocation:
(int) accuracy
        locationTimeout:
        (int) locationTimeout
        reGeocodeTimeout:
        (int) reGeocodeTimeout
        resolver:
        (RCTPromiseResolveBlock) resolve
        rejecter:
        (RCTPromiseRejectBlock) reject)
{
    if (accuracy == 0) {
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    } else if (accuracy == 1) {
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    } else if (accuracy == 2) {
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    } else if (accuracy == 3) {
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    _locationManager.locationTimeout = locationTimeout;
    _locationManager.reGeocodeTimeout = reGeocodeTimeout;
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {

        if (error) {
            NSLog(@"locError:{%ld - %@};", (long) error.code, error.localizedDescription);
            reject(@"location", error.localizedDescription, error);
        } else {
            NSLog(@"location:%@", location);
            NSLog(@"reGeocode:%@", regeocode);
            if (regeocode) {
                resolve(@{
                        @"latitude" : @(location.coordinate.latitude),
                        @"longitude" : @(location.coordinate.longitude),
                        @"accuracy" : location.horizontalAccuracy ? @(location.horizontalAccuracy) : @"",
                        @"reGeocode" : @{
                                @"formattedAddress" : regeocode.formattedAddress != nil ? regeocode.formattedAddress : @"",
                                @"country" : regeocode.country != nil ? regeocode.country : @"",
                                @"province" : regeocode.province != nil ? regeocode.province : @"",
                                @"city" : regeocode.city != nil ? regeocode.city : @"",
                                @"district" : regeocode.district != nil ? regeocode.district : @"",
                                @"township" : regeocode.township != nil ? regeocode.township : @"",
                                @"street" : regeocode.street != nil ? regeocode.township : @"",
                                @"number" : regeocode.number != nil ? regeocode.number : @"",
                                @"POIName" : regeocode.POIName != nil ? regeocode.POIName : @"",
                                @"AOIName" : regeocode.AOIName != nil ? regeocode.AOIName : @"",
                                @"neighborhood" : regeocode.neighborhood != nil ? regeocode.neighborhood : @"",
                                @"building" : regeocode.building != nil ? regeocode.building : @"",
                                @"citycode" : regeocode.citycode != nil ? regeocode.citycode : @"",
                                @"adcode" : regeocode.adcode != nil ? regeocode.adcode : @"",
                        },
                });
            } else {
                resolve(@{
                        @"latitude" : @(location.coordinate.latitude),
                        @"longitude" : @(location.coordinate.longitude),
                        @"accuracy" : location.horizontalAccuracy ? @(location.horizontalAccuracy) : @"",
                        @"reGeocode" : @{},
                });
            }
        }
    }];
}


- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    [self.bridge.eventDispatcher sendAppEventWithName:@"AMapUpdateLocation" body:@{
            @"latitude" : @(location.coordinate.latitude),
            @"longitude" : @(location.coordinate.longitude),
            @"accuracy" : @(location.horizontalAccuracy),
    }];
}

@end