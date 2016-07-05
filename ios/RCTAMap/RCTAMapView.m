//
// Created by 刘思贤 on 16/6/27.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import "RCTAMapView.h"
#import "RCTAMapAnnotationView.h"

#import <MAMapKit/MAMapView.h>
#import <AMapFoundationKit/AMapServices.h>

#import "RCTUtils.h"


@interface RCTAMapView () <MAMapViewDelegate>

@end


@implementation RCTAMapView
{
    NSMutableArray<UIView *> *_reactSubviews;
}

- (instancetype)init
{
    if (self = [super init]) {
        _reactSubviews = [NSMutableArray new];
        _allGesturesEnabled = YES;
        _rotateGesturesEnabled = YES;
        _scrollGesturesEnabled = YES;
        _zoomGesturesEnabled = YES;
        [AMapServices sharedServices].apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AMapApiKey"];
    }

    return self;
}

- (void)loadMap
{
    if (!_mapView) {
        if (!(self.bounds.size.height > 0 && self.bounds.size.width > 0)) {
            return;
        }
        _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
        _mapView.delegate = self;
        [self addSubview:_mapView];
        if (_defaultRegion.center.latitude && _defaultRegion.center.longitude) {
            [_mapView setRegion:_defaultRegion animated:NO];
        }

        for (UIView *subview in _reactSubviews) {
            [self addAMapSubview:subview];
        }
    }

    // Setting map properties
    if (_mapType && [[_mapType lowercaseString] isEqualToString:@"normal"]) {
        self.mapView.mapType = MAMapTypeStandard;
    } else if (_mapType && [[_mapType lowercaseString] isEqualToString:@"satellite"]) {
        self.mapView.mapType = MAMapTypeSatellite;
    } else if (_mapType && [[_mapType lowercaseString] isEqualToString:@"night"]) {
        self.mapView.mapType = MAMapTypeStandardNight;
    }

    if (_myLocationType && [[_myLocationType lowercaseString] isEqualToString:@"locate"]) {
        self.mapView.userTrackingMode = MAUserTrackingModeNone;
    } else if (_myLocationType && [[_myLocationType lowercaseString] isEqualToString:@"follow"]) {
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    } else if (_myLocationType && [[_myLocationType lowercaseString] isEqualToString:@"rotate"]) {
        self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    }

    self.mapView.showsUserLocation = _myLocationEnabled;
    self.mapView.showsCompass = _compassEnabled;
    self.mapView.showTraffic = _trafficEnabled;
    self.mapView.showsIndoorMap = _indoorSwitchEnabled;
    self.mapView.rotateEnabled = _allGesturesEnabled && _rotateGesturesEnabled;
    self.mapView.scrollEnabled = _allGesturesEnabled && _scrollGesturesEnabled;
    self.mapView.zoomEnabled = _allGesturesEnabled && _zoomGesturesEnabled;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self loadMap];
}

UPDATE_PROP(NSString *, logoPosition);

UPDATE_PROP(NSString *, mapType);

UPDATE_PROP(BOOL, myLocationEnabled);

UPDATE_PROP(NSString *, myLocationType);

UPDATE_PROP(BOOL, allGesturesEnabled);

UPDATE_PROP(BOOL, compassEnabled);

UPDATE_PROP(BOOL, indoorSwitchEnabled);

UPDATE_PROP(BOOL, rotateGesturesEnabled);

UPDATE_PROP(BOOL, scrollGesturesEnabled);

UPDATE_PROP(BOOL, trafficEnabled);

UPDATE_PROP(BOOL, zoomGesturesEnabled);

- (void)setRegion:(MACoordinateRegion)region animated:(BOOL)animated
{
    if (_mapView) {
        [_mapView setRegion:region animated:animated];
    }
}

- (void)addAMapSubview:(UIView *)subview
{
    if (_mapView) {
        if ([subview isKindOfClass:[RCTAMapAnnotationView class]]) {
            [_mapView addAnnotation:(RCTAMapAnnotationView *) subview];
        }
    }
}

- (void)insertReactSubview:(id <RCTComponent>)subview atIndex:(NSInteger)atIndex
{
    if (_mapType) {
        [self addAMapSubview:subview];
    }
    [_reactSubviews insertObject:(UIView *) subview atIndex:(NSUInteger) atIndex];
}

- (void)removeReactSubview:(id <RCTComponent>)subview
{
    if (_mapView) {
        if ([subview isKindOfClass:[RCTAMapAnnotationView class]]) {
            [_mapView removeAnnotation:(RCTAMapAnnotationView *) subview];
        }
    }
    [_reactSubviews removeObject:(UIView *) subview];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RCTAMapAnnotationView class]]) {
        return [(RCTAMapAnnotationView *) annotation getAnnotationView];
    }

    return nil;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.onRegionChange) {
        MACoordinateRegion region = mapView.region;
        if (!CLLocationCoordinate2DIsValid(region.center)) {
            return;
        }

        self.onRegionChange(@{
                @"region" : @{
                        @"latitude" : @(RCTZeroIfNaN(region.center.latitude)),
                        @"longitude" : @(RCTZeroIfNaN(region.center.longitude)),
                        @"latitudeDelta" : @(RCTZeroIfNaN(region.span.latitudeDelta)),
                        @"longitudeDelta" : @(RCTZeroIfNaN(region.span.longitudeDelta)),
                }
        });
    }
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    if (self.onMove) {
        CLLocationCoordinate2D coordinate = [self.mapView centerCoordinate];
        self.onMove(@{
                @"isUserAction" : @(wasUserAction),
                @"coordinate" : @{
                        @"latitude" : @(coordinate.latitude),
                        @"longitude" : @(coordinate.longitude),
                }
        });
    }
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction
{
    if (self.onZoom) {
        CLLocationCoordinate2D coordinate = [self.mapView centerCoordinate];
        self.onZoom(@{
                @"isUserAction" : @(wasUserAction),
                @"coordinate" : @{
                        @"latitude" : @(coordinate.latitude),
                        @"longitude" : @(coordinate.longitude),
                },
                @"zoom" : @(self.mapView.zoomLevel),
        });
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (self.onUpdateLocation) {
        self.onUpdateLocation(@{
                @"updatingLocation" : @(updatingLocation),
                @"userLocation" : @{
                        @"coordinate" : @{
                                @"latitude" : @(userLocation.location.coordinate.latitude),
                                @"longitude" : @(userLocation.location.coordinate.latitude),
                        },
                }
        });
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    RCTAMapAnnotationView *rctView = nil;

    if ([view isKindOfClass:[MAPinAnnotationView class]]
            && [((MAPinAnnotationView *)view).annotation isKindOfClass:[RCTAMapAnnotationView class]]) {
        rctView  = (RCTAMapAnnotationView *)((MAPinAnnotationView *)view).annotation;
    } else if ([view isKindOfClass:[RCTAMapAnnotationView class]]) {
        rctView = (RCTAMapAnnotationView *)view;
    }

    if (rctView) {
        if (rctView.onSelect) rctView.onSelect(@{
                    @"coordinate" : @{
                            @"latitude" : @(rctView.coordinate.latitude),
                            @"longitude" : @(rctView.coordinate.latitude),
                    },
            });
    }
}


@end

