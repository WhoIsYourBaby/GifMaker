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
#import "SettingBundle.h"
#import "AnimatedGIFImageSerialization.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"


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


- (NSString *)gifLocalFolder
{
    NSString *fp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *gf = [fp stringByAppendingPathComponent:kGifGroupName];
    BOOL isFolder = NO;
    NSError *err = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:gf isDirectory:&isFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:gf withIntermediateDirectories:YES attributes:nil error:&err];
    } else {
        if (!isFolder) {
            [[NSFileManager defaultManager] createDirectoryAtPath:gf withIntermediateDirectories:YES attributes:nil error:&err];
        }
    }
    if (err) {
        NSLog(@"%s --> %@", __func__, err);
    }
    return gf;
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


- (void)saveEditImage:(UIImage *)bigImg withImgName:(NSString *)name;
{
    NSString *jpgBigPath = [[self docTempBig] stringByAppendingPathComponent:name];
    
    NSData *bigImgData = UIImageJPEGRepresentation(bigImg, 1.0);
    if (![bigImgData writeToFile:jpgBigPath atomically:NO]) {
        NSLog(@"%s -> %@", __FUNCTION__, jpgBigPath);
    }
    
    NSString *jpgLitPath = [[self docTempLittle] stringByAppendingPathComponent:name];
    UIImage *litImg = [bigImg imageByScalingToCustomSize:k_Size_little];
    NSData *litImgData = UIImageJPEGRepresentation(litImg, 1.0);
    if (![litImgData writeToFile:jpgLitPath atomically:NO]) {
        NSLog(@"%s -> %@", __FUNCTION__, litImgData);
    }
}


- (void)removeImageWithName:(NSString *)name
{
    NSString *jpgBigPath = [[self docTempBig] stringByAppendingPathComponent:name];
    NSError *err = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:jpgBigPath error:&err]) {
        [err alert];
    }
    NSString *jpgLitPath = [[self docTempLittle] stringByAppendingPathComponent:name];
    if (![[NSFileManager defaultManager] removeItemAtPath:jpgLitPath error:&err]) {
        [err alert];
    }
}


- (NSString *)saveTempImage:(UIImage *)bigImg
{
    double time = [[NSDate date] timeIntervalSince1970];
    NSString *jpgName = [NSString stringWithFormat:@"%f.jpg", time];
    
    NSString *jpgBigPath = [[self docTempBig] stringByAppendingPathComponent:jpgName];
    
    bigImg = [HWDevice fixOrientation:bigImg];
    
    NSData *bigImgData = UIImageJPEGRepresentation(bigImg, 0.8);
    if (![bigImgData writeToFile:jpgBigPath atomically:NO]) {
        NSLog(@"%s -> %@", __FUNCTION__, jpgBigPath);
    }
    
    NSString *jpgLitPath = [[self docTempLittle] stringByAppendingPathComponent:jpgName];
    UIImage *litImg = [bigImg imageByScalingToCustomSize:k_Size_little];
    NSData *litImgData = UIImageJPEGRepresentation(litImg, 0.8);
    if (![litImgData writeToFile:jpgLitPath atomically:NO]) {
        NSLog(@"%s -> %@", __FUNCTION__, litImgData);
    }
    return jpgName;
}

- (NSString *)saveTempImageJEPG:(NSData *)imgData
{
    UIImage *bigImg = [UIImage imageWithData:imgData];
    return [self saveTempImage:bigImg];
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

- (NSArray *)bigTempImageArrayWithNames:(NSArray *)aNameArr
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < aNameArr.count; i ++) {
        UIImage *img = [self bigTempImageWithName:aNameArr[i]];
        [arr addObject:img];
    }
    return arr;
}

- (NSArray *)imageArrayInTemp
{
    NSArray *stArr = [self imageNameArrayInTemp];
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:256];
    for (int i = 0; i < [stArr count]; i ++) {
        UIImage *img = [[GifManager shareInterface] bigTempImageWithName:stArr[i]];
        [imgArr addObject:img];
    }
    return imgArr;
}


- (NSArray *)imageNameArrayInTemp
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fNameArr = [fm subpathsAtPath:[self docTempBig]];
    NSArray *stNameArr = [fNameArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *name1 = (NSString *)obj1;
        NSString *name2 = (NSString *)obj2;
        double dt1 = [[name1 stringByDeletingPathExtension] doubleValue];
        double dt2 = [[name2 stringByDeletingPathExtension] doubleValue];
        if (dt1 < dt2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return stNameArr;
}


- (ALAssetsLibrary *)albumLibrary
{
    if (_albumLibrary == nil) {
        _albumLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _albumLibrary;
}


- (NSMutableArray *)gifMakerAssets
{
    if (_gifMakerAssets == nil) {
        _gifMakerAssets = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _gifMakerAssets;
}


- (void)enumerateAlbumGifAssets:(void (^)(NSMutableArray *myGifAssets))resultBlock
{
    // setup our failure view controller in case enumerateGroupsWithTypes fails
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    };
    
    // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        if ([groupName isEqualToString:kGifGroupName]) {
            ALAssetsFilter *allFilter = [ALAssetsFilter allAssets];
            [group setAssetsFilter:allFilter];
            self.myGifGroup = group;
            //停止遍历
            *stop = YES;
        }
        //遍历group完成后开始遍历Assets
        if (group == nil) {
            [self enumerateAssetsInGifGroup:resultBlock];
        }
    };
    
    // enumerate photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupSavedPhotos;
    [self.albumLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

- (void)enumerateAssetsInGifGroup:(void (^)(NSMutableArray *myGifAssets))resultBlock
{
    //如果不存在
    ALAssetsLibraryGroupResultBlock blcresult = ^(ALAssetsGroup *group) {
        //success
        self.myGifGroup = group;
    };
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *error) {
        if (resultBlock) {
            resultBlock(nil);
        }
    };
    if (self.myGifGroup == nil) {
        [self.albumLibrary addAssetsGroupAlbumWithName:kGifGroupName resultBlock:blcresult failureBlock:failure];
    }
    
    if ([self.myGifGroup numberOfAssets] > 0) {
        [self.myGifGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                //遍历完成
                if (resultBlock) {
                    resultBlock(self.gifMakerAssets);
                }
            } else {
                [self.gifMakerAssets addObject:result];
            }
        }];
    } else {
        NSLog(@"%s -> No Assets in GifMaker", __FUNCTION__);
    }
}



- (void)makeGifInAlbum:(UIImage *)aImg
{
    NSTimeInterval duration = [[SettingBundle globalSetting] timeInterval] * aImg.images.count;
    NSError *err = nil;
    NSData *gifData = [AnimatedGIFImageSerialization animatedGIFDataWithImage:aImg duration:duration loopCount:0 error:&err];
    [self.albumLibrary saveGifData:gifData toAlbum:kGifGroupName withCompletionBlock:^(NSError *error) {
        NSLog(@"%s -->%@", __func__, err);
    }];
}



- (void)makeGifInLocal:(UIImage *)aImg
{
    NSString *fp = [self gifLocalFolder];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"%d.gif", (int)time];
    fp = [fp stringByAppendingPathComponent:name];
    
    NSTimeInterval duration = [[SettingBundle globalSetting] timeInterval] * aImg.images.count;
    NSError *err = nil;
    NSData *gifData = [AnimatedGIFImageSerialization animatedGIFDataWithImage:aImg duration:duration loopCount:0 error:&err];
    [gifData writeToFile:fp atomically:YES];
}

@end
