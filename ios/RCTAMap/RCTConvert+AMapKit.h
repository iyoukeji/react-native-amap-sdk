//
// Created by 刘思贤 on 16/6/27.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import "RCTConvert.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface RCTConvert (AMapKit)

+ (MACoordinateSpan)MACoordinateSpan:(id)json;
+ (MACoordinateRegion)MACoordinateRegion:(id)json;
+ (AMapGeoPoint *)AMapGeoPoint:(id)json;

@end
