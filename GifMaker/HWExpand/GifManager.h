//
//  GifManager.h
//  GifMaker
//
//  Created by HalloWorld on 14-10-2.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define k_Size_little CGSizeMake(60.f, 70.f)    //小图片size


@interface GifManager : NSObject

@property (strong, nonatomic) ALAssetsLibrary *albumLibrary;
@property (strong, nonatomic) ALAssetsGroup *myGifGroup;
@property (strong, nonatomic) NSMutableArray *gifMakerAssets;

+ (instancetype)shareInterface;

- (void)cleanTempDir;

- (NSString *)saveTempImageJEPG:(NSData *)imgData;
- (NSString *)saveTempImage:(UIImage *)img;
- (void)saveEditImage:(UIImage *)bigImg withImgName:(NSString *)name;
- (void)removeImageWithName:(NSString *)name;

- (UIImage *)littleTempImageWithName:(NSString *)aName;
- (UIImage *)bigTempImageWithName:(NSString *)aName;
- (NSArray *)bigTempImageArrayWithNames:(NSArray *)aNameArr;

- (NSArray *)imageArrayInTemp;

- (NSArray *)imageNameArrayInTemp;


//获取成品

- (void)makeGifInLocal:(UIImage *)aImg;
- (void)makeGifInAlbum:(UIImage *)aImg;

- (void)enumerateAlbumGifAssets:(void (^)(NSMutableArray *myGifAssets))resultBlock;


@end
