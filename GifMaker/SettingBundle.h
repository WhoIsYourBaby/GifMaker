//
//  SettingBundle.h
//  GifMaker
//
//  Created by cdsbmac on 14/11/24.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SettingMethodAuto,
    SettingMethodManual
} SettingMethodEnum;


@interface SettingBundle : NSObject

+ (instancetype)globalSetting;

@property CGFloat timeInterval;
@property int countOfImage;
@property SettingMethodEnum methodCate;

- (void)synchronize;

@end
