//
//  HWViewController.m
//  GifMaker
//
//  Created by cdsbmac on 14/11/26.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWViewController.h"

@implementation HWViewController

+ (instancetype)quickInstance
{
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
