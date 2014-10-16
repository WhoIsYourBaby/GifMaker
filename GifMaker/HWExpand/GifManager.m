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

- (void)cleanTempDir
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
        if (![fm removeItemAtPath:itemPath error:&err]) {
            NSLog(@"%s -> %@", __FUNCTION__, err);
        }
    }
}


- (NSString *)saveTempImageJEPG:(NSData *)imgData
{
    NSString *jpgName = [[HWDevice uuidString] stringByAppendingPathExtension:@".jpg"];
    
    NSString *jpgBigPath = [[self docTempBig] stringByAppendingPathComponent:jpgName];
    UIImage *bigImg = [UIImage imageWithData:imgData];
    
//    bigImg = [self bestImage:bigImg];
    
    NSData *bigImgData = UIImageJPEGRepresentation(bigImg, 0.5);
    if (![bigImgData writeToFile:jpgBigPath atomically:YES]) {
        NSLog(@"%s -> %@", __FUNCTION__, jpgBigPath);
    }
    
    NSString *jpgLitPath = [[self docTempLittle] stringByAppendingPathComponent:jpgName];
    UIImage *litImg = [bigImg imageByScalingToCustomSize:k_Size_little];
    NSData *litImgData = UIImageJPEGRepresentation(litImg, 0.5);
    if (![litImgData writeToFile:jpgLitPath atomically:YES]) {
        NSLog(@"%s -> %@", __FUNCTION__, litImgData);
    }
    return jpgName;
}


//返回适配屏幕大小的image
- (UIImage *)bestImage:(UIImage *)aImg
{
    CGRect rrr = [[UIScreen mainScreen] applicationFrame];
    CGSize aSize = [aImg size];
    CGFloat screenScale = 1.f;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        screenScale = screenScale * [[UIScreen mainScreen] scale];
    }
    rrr = CGRectMake(0, 0, rrr.size.width * screenScale, rrr.size.height * screenScale);
    float originX = (aSize.width - rrr.size.width) / 2.f;
    float originY = (aSize.height - rrr.size.height) / 2.f;
    if (originY < 0 || originX < 0) {
        NSLog(@"%s -> 错误的Image Size : %@, applicationFrame : %@", __FUNCTION__, NSStringFromCGSize(aSize), NSStringFromCGRect(rrr));
    }
    rrr.origin.x = originX;
    rrr.origin.y = originY;
    
    return [aImg imageAtRect:rrr];
}


- (UIImage *)littleTempImageWithName:(NSString *)aName
{
    NSString *filePath = [[self docTempLittle] stringByAppendingPathComponent:aName];
    return [UIImage imageWithContentsOfFile:filePath];
}


- (UIImage *)bigTempImageWithName:(NSString *)aName
{
    NSString *filePath = [[self docTempBig] stringByAppendingPathComponent:aName];
    return [UIImage imageWithContentsOfFile:filePath];
}


@end
