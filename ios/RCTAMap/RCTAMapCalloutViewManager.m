//
// Created by 刘思贤 on 16/6/29.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import "RCTAMapCalloutViewManager.h"
#import "RCTAMapCalloutView.h"


@implementation RCTAMapCalloutViewManager

RCT_EXPORT_MODULE()


- (UIView *)view
{
    return [RCTAMapCalloutView new];
}

@end