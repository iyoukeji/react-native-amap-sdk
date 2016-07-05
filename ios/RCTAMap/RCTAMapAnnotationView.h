//
// Created by 刘思贤 on 16/6/29.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <React/RCTBridge.h>
#import <React/RCTConvert+CoreLocation.h>
#import <MAMapKit/MAAnnotationView.h>

#import "RCTAMapView.h"
#import "RCTAMapCalloutView.h"

@class RCTAMapView;
@class RCTBridge;
@class RCTAMapCalloutView;


@interface RCTAMapAnnotationView : MAAnnotationView <MAAnnotation>

@property (nonatomic, strong) RCTAMapCalloutView *calloutView;
@property (nonatomic, weak) RCTAMapView *mapView;
@property (nonatomic, weak) RCTBridge *bridge;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, copy) NSString *imageSrc;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *pinColor;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) RCTDirectEventBlock onSelect;


- (MAAnnotationView *)getAnnotationView;


@end