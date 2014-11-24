//
//  SettingBundle.m
//  GifMaker
//
//  Created by cdsbmac on 14/11/24.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "SettingBundle.h"

@implementation SettingBundle

+ (instancetype)defaultSetting
{
    return [[SettingBundle alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeInterval = 0.1;
        self.methodCate = SettingMethodAuto;
        self.countOfImage = 16;
    }
    return self;
}

@end
