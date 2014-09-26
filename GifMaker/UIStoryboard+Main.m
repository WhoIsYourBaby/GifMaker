//
//  UIStoryboard+Main.m
//  GifMaker
//
//  Created by HalloWorld on 14-9-26.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "UIStoryboard+Main.h"

@implementation UIStoryboard (Main)

+ (UIStoryboard *)mainStoryBoard
{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        return [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        return [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
}

@end
