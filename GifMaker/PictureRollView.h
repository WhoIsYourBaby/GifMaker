//
//  PictureRollView.h
//  GifMaker
//
//  Created by HalloWorld on 14-10-5.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureRollView : UIScrollView
{
    int countOfPic;
}

- (void)addPicture:(UIImage *)aImg;

@end
