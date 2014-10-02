//
//  GifManager.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-2.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "GifManager.h"

static GifManager *interface = nil;

@implementation GifManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //init todo
    }
    return self;
}

+ (instancetype)shareInterface
{
    if (interface == nil) {
        interface = [[GifManager alloc] init];
    }
    return interface;
}

@end
