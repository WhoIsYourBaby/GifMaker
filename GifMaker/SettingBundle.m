//
//  SettingBundle.m
//  GifMaker
//
//  Created by cdsbmac on 14/11/24.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "SettingBundle.h"

@implementation SettingBundle

+ (instancetype)globalSetting
{
    return [[SettingBundle alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"SettingBundle"];
        if (dic) {
            self.timeInterval = [[dic objectForKey:@"timeInterval"] floatValue];
            self.methodCate = [[dic objectForKey:@"methodCate"] intValue];
            self.countOfImage = [[dic objectForKey:@"countOfImage"] intValue];
        } else {
            self.timeInterval = 0.1;
            self.methodCate = SettingMethodAuto;
            self.countOfImage = 16;
        }
    }
    return self;
}

- (void)synchronize
{
    NSDictionary *dic = @{@"timeInterval" : [NSString stringWithFormat:@"%.1f", self.timeInterval],
                          @"methodCate" : [NSNumber numberWithInt:self.methodCate],
                          @"countOfImage" : [NSNumber numberWithInt:self.countOfImage]};
    NSLog(@"%s  -->  %@", __func__, dic);
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"SettingBundle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
    [self synchronize];
}

@end
