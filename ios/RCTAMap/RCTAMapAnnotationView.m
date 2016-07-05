//
// Created by 刘思贤 on 16/6/29.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import "RCTAMapAnnotationView.h"

#import "UIView+React.h"
#import "RCTUtils.h"
#import "RCTImageLoader.h"

@interface MAPinAnnotationViewProxy : MAPinAnnotationView
@end


@implementation MAPinAnnotationViewProxy

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if ([self.annotation isKindOfClass:[RCTAMapAnnotationView class]]) {
        RCTAMapAnnotationView *rctView = (RCTAMapAnnotationView *) self.annotation;
        if (rctView.calloutView) {
            if (selected) {
                rctView.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                        -CGRectGetHeight(rctView.calloutView.bounds) / 2.f + self.calloutOffset.y);
                [self addSubview:rctView.calloutView];
            } else {
                [rctView.calloutView removeFromSuperview];
            }
        }
    }

    [super setSelected:selected animated:animated];
}

@end


@implementation RCTAMapAnnotationView
{
    MAPinAnnotationView *_pinView;
    RCTImageLoaderCancellationBlock _reloadImageCancellationBlock;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.canShowCallout = YES;
    }

    return self;
}


- (void)insertReactSubview:(id <RCTComponent>)subview atIndex:(NSInteger)atIndex
{
    if ([subview isKindOfClass:[RCTAMapCalloutView class]]) {
        self.calloutView = (RCTAMapCalloutView *) subview;
        self.canShowCallout = NO;
    } else {
        [super insertReactSubview:subview atIndex:atIndex];
    }
}

- (void)removeReactSubview:(id <RCTComponent>)subview
{
    if ([subview isKindOfClass:[RCTAMapCalloutView class]] && self.calloutView == subview) {
        self.calloutView = nil;
    } else {
        [super removeReactSubview:subview];
    }
}


- (MAAnnotationView *)getAnnotationView
{
    // If no image src, use the pin annotation
    if (_imageSrc == nil) {
        if (_pinView == nil) {
            _pinView = [[MAPinAnnotationViewProxy alloc] initWithAnnotation:self reuseIdentifier:nil];
            _pinView.annotation = self;
        }
        _pinView.draggable = self.draggable;
        _pinView.canShowCallout = self.canShowCallout;
        _pinView.centerOffset = self.centerOffset;
        _pinView.calloutOffset = self.calloutOffset;
        _pinView.enabled = self.enabled;
        _pinView.highlighted = self.highlighted;
        [self setPinColor:_pinColor];

        return _pinView;
    } else {
        return self;
    }
}

- (void)setImageSrc:(NSString *)imageSrc
{
    _imageSrc = imageSrc;

    if (_reloadImageCancellationBlock) {
        _reloadImageCancellationBlock();
        _reloadImageCancellationBlock = nil;
    }

    _reloadImageCancellationBlock = [_bridge.imageLoader loadImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_imageSrc]]
                                                                            size:self.bounds.size
                                                                           scale:RCTScreenScale()
                                                                         clipped:NO
                                                                      resizeMode:RCTResizeModeCover
                                                                   progressBlock:nil
                                                                 completionBlock:^(NSError *error, UIImage *image) {
                                                                     if (error) {
                                                                         NSLog(@"%@", error);
                                                                     }
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         self.image = image;
                                                                     });
                                                                 }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) {
        return;
    }

    if (_calloutView) {
        if (selected) {
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                    -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            [self addSubview:self.calloutView];
        } else {
            [self.calloutView removeFromSuperview];
        }
    }

    [super setSelected:selected animated:animated];
}

- (void)setPinColor:(NSString *)pinColor
{
    _pinColor = pinColor;
    if (_pinColor == nil || _pinView == nil) return;
    if ([[_pinColor lowercaseString] isEqualToString:@"red"]) {
        _pinView.pinColor = MAPinAnnotationColorRed;
    } else if ([[_pinColor lowercaseString] isEqualToString:@"green"]) {
        _pinView.pinColor = MAPinAnnotationColorGreen;
    } else if ([[_pinColor lowercaseString] isEqualToString:@"purple"]) {
        _pinView.pinColor = MAPinAnnotationColorPurple;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset
{
    [super setCenterOffset:centerOffset];
    if (_pinView) _pinView.centerOffset = centerOffset;
}

- (void)setCalloutOffset:(CGPoint)calloutOffset
{
    [super setCalloutOffset:calloutOffset];
    if (_pinView) _pinView.calloutOffset = calloutOffset;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (_pinView) _pinView.enabled = enabled;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (_pinView) _pinView.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (_pinView) _pinView.selected = selected;
}

- (void)setDraggable:(BOOL)draggable
{
    [super setDraggable:draggable];
    if (_pinView) _pinView.draggable = draggable;
}

@end