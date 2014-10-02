//
//  GifManager.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-2.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "GifManager.h"
#import "UIImage+Expand.h"
#import "HWDevice.h"

#define k_Doc_temp_big @"temp/big"
#define k_Doc_temp_little @"temp/little"

#define k_Size_little CGSizeMake(50.f, 70.f)

static GifManager *interface = nil;

@implementation GifManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //init todo
        [self initDir];
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

- (NSString *)docTempBig
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docDir stringByAppendingPathComponent:k_Doc_temp_big];
}


- (NSString *)docTempLittle
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docDir stringByAppendingPathComponent:k_Doc_temp_little];
}


- (void)initDir
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *err = nil;
    NSString *tempBig = [self docTempBig];
    [fm createDirectoryAtPath:tempBig withIntermediateDirectories:YES attributes:nil error:&err];
    if (err) {
        NSLog(@"%s -> %@", __FUNCTION__, err);
    }
    
    NSString *tempLittle = [self docTempLittle];
    [fm createDirectoryAtPath:tempLittle withIntermediateDirectories:YES attributes:nil error:&err];
    if (err) {
        NSLog(@"%s -> %@", __FUNCTION__, err);
    }
}

- (void)clean
{
    [self cleanInDir:[self docTempBig]];
    [self cleanInDir:[self docTempLittle]];
}

- (void)cleanInDir:(NSString *)dirPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *bigArr = [fm subpathsAtPath:dirPath];
    NSError *err = nil;
    for (NSString *subItem in bigArr) {
        NSString *itemPath = [dirPath stringByAppendingPathComponent:subItem];
        [fm removeItemAtPath:itemPath error:&err];
        NSLog(@"%s -> %@", __FUNCTION__, err);
    }
}


- (void)saveTempImageJEPG:(NSData *)imgData
{
    NSString *jpgName = [[HWDevice uuidString] stringByAppendingPathExtension:@".jpg"];
    
    NSString *jpgBigPath = [[self docTempBig] stringByAppendingPathComponent:jpgName];
    UIImage *bigImg = [UIImage imageWithData:imgData];
    NSData *bigImgData = UIImageJPEGRepresentation(bigImg, 0.5);
    if (![bigImgData writeToFile:jpgBigPath atomically:YES]) {
        NSLog(@"%s -> %@", __FUNCTION__, jpgBigPath);
    }
    
    NSString *jpgLitPath = [[self docTempLittle] stringByAppendingPathComponent:jpgName];
    UIImage *litImg = [bigImg imageByScalingProportionallyToSize:k_Size_little];
    NSData *litImgData = UIImageJPEGRepresentation(litImg, 0.5);
    if (![litImgData writeToFile:jpgLitPath atomically:YES]) {
        NSLog(@"%s -> %@", __FUNCTION__, litImgData);
    }
}

@end
