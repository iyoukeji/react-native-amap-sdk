//
// Created by 刘思贤 on 16/6/27.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import "RCTConvert+AMapKit.h"
#import <MAMapKit/MAMapKit.h>
#import "RCTConvert+CoreLocation.h"

@implementation RCTConvert (AMapKit)
+ (MACoordinateSpan)MACoordinateSpan:(id)json
{
    json = [self NSDictionary:json];
    return (MACoordinateSpan) {
            [self CLLocationDegrees:json[@"latitudeDelta"]],
            [self CLLocationDegrees:json[@"longitudeDelta"]]

    };
}

+ (MACoordinateRegion)MACoordinateRegion:(id)json
{
    json = [self NSDictionary:json];
    return (MACoordinateRegion) {
            [self CLLocationCoordinate2D:json],
            [self MACoordinateSpan:json]
    };
}

+ (AMapGeoPoint *)AMapGeoPoint:(id)json
{
    json = [self NSDictionary:json];
    return [AMapGeoPoint locationWithLatitude:
                    [self CGFloat:json[@"latitude"]]
                                    longitude:[self CGFloat:json[@"longitude"]]];
}
@end
