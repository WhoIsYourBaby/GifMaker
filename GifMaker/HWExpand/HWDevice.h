//
//  HWDevice.h
//  WanKe
//
//  Created by HalloWorld on 14-3-30.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLOR_RGB(x, y, z) [UIColor colorWithRed:(x)/255.f green:(y)/255.f blue:(z)/255.f alpha:1.0]
#define COLOR_RGBA(x, y, z, a) [UIColor colorWithRed:(x)/255.f green:(y)/255.f blue:(z)/255.f alpha:(a)/255.f]

@interface HWDevice : NSObject

/**
 *  返回IOS版本浮点
 */
+ (float)systemVersion;

+ (NSString *)dateString:(NSDate *)date;

+ (NSString *)uuidString;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (NSString *)getDeviceName;

@end

@interface NSError (HWDevice)

- (void)alert;

@end