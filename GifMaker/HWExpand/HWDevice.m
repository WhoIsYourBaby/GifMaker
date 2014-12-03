//
//  HWDevice.m
//  WanKe
//
//  Created by HalloWorld on 14-3-30.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWDevice.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

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

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (NSString *)getDeviceVersionInfo
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithFormat:@"%s", systemInfo.machine];
    
    return platform;
}

+ (NSString *)getDeviceName
{
    NSString *correspondVersion = [self getDeviceVersionInfo];
    
    if ([correspondVersion isEqualToString:@"i386"])        return @"Simulator";
    if ([correspondVersion isEqualToString:@"x86_64"])      return @"Simulator";
    if ([correspondVersion isEqualToString:@"iPhone1,1"])   return @"iPhone 1";
    if ([correspondVersion isEqualToString:@"iPhone1,2"])   return @"iPhone 3";
    if ([correspondVersion isEqualToString:@"iPhone2,1"])   return @"iPhone 3S";
    if ([correspondVersion isEqualToString:@"iPhone3,1"] ||
        [correspondVersion isEqualToString:@"iPhone3,2"])   return @"iPhone 4";
    if ([correspondVersion isEqualToString:@"iPhone4,1"])   return @"iPhone 4S";
    if ([correspondVersion isEqualToString:@"iPhone5,1"] ||
        [correspondVersion isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
    if ([correspondVersion isEqualToString:@"iPhone5,3"] ||
        [correspondVersion isEqualToString:@"iPhone5,4"])   return @"iPhone 5C";
    if ([correspondVersion isEqualToString:@"iPhone6,1"] ||
        [correspondVersion isEqualToString:@"iPhone6,2"])   return @"iPhone 5S";
    if ([correspondVersion isEqualToString:@"iPhone7,2"])   return @"iPhone 6";
    if ([correspondVersion isEqualToString:@"iPhone7,1"])   return @"iPhone 6Plus";
    if ([correspondVersion isEqualToString:@"iPod1,1"])     return @"iPod Touch 1";
    if ([correspondVersion isEqualToString:@"iPod2,1"])     return @"iPod Touch 2";
    if ([correspondVersion isEqualToString:@"iPod3,1"])     return @"iPod Touch 3";
    if ([correspondVersion isEqualToString:@"iPod4,1"])     return @"iPod Touch 4";
    if ([correspondVersion isEqualToString:@"iPod5,1"])     return @"iPod Touch 5";
    if ([correspondVersion isEqualToString:@"iPad1,1"])     return @"iPad 1";
    if ([correspondVersion isEqualToString:@"iPad2,1"] ||
        [correspondVersion isEqualToString:@"iPad2,2"] ||
        [correspondVersion isEqualToString:@"iPad2,3"] ||
        [correspondVersion isEqualToString:@"iPad2,4"])     return @"iPad 2";
    if ([correspondVersion isEqualToString:@"iPad2,5"] ||
        [correspondVersion isEqualToString:@"iPad2,6"] ||
        [correspondVersion isEqualToString:@"iPad2,7"] )    return @"iPad Mini";
    if ([correspondVersion isEqualToString:@"iPad3,1"] ||
        [correspondVersion isEqualToString:@"iPad3,2"] ||
        [correspondVersion isEqualToString:@"iPad3,3"] ||
        [correspondVersion isEqualToString:@"iPad3,4"] ||
        [correspondVersion isEqualToString:@"iPad3,5"] ||
        [correspondVersion isEqualToString:@"iPad3,6"])     return @"iPad 3";
    
    return correspondVersion;
}

@end


@implementation NSError (HWDevice)

- (void)alert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self domain] message:[self description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
}

@end