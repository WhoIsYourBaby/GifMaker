//
//  GifManager.h
//  GifMaker
//
//  Created by HalloWorld on 14-10-2.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

#define k_Size_little CGSizeMake(60.f, 70.f)    //小图片size


@interface GifManager : NSObject


+ (instancetype)shareInterface;

- (void)cleanTempDir;

- (NSString *)saveTempImageJEPG:(NSData *)imgData;
- (NSString *)saveTempImage:(UIImage *)img;
- (void)saveEditImage:(UIImage *)bigImg withImgName:(NSString *)name;

- (UIImage *)littleTempImageWithName:(NSString *)aName;
- (UIImage *)bigTempImageWithName:(NSString *)aName;

- (NSArray *)imageArrayInTemp;

- (NSArray *)imageNameArrayInTemp;

@end
