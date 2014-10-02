//
//  HWDevice.m
//  WanKe
//
//  Created by HalloWorld on 14-3-30.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWDevice.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HWDevice

+ (float)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)dateString:(NSDate *)date;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:(date == nil ? [NSDate date] : date)];
}

+ (NSString *)uuidString
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end