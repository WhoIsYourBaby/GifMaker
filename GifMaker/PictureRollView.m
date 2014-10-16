//
//  PictureRollView.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-5.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "PictureRollView.h"
#import "GifManager.h"

#define litRectWidth 6

@implementation PictureRollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        countOfPic = 0;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGSize cSize = self.frame.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    int count = cSize.width / litRectWidth;
    [[UIColor purpleColor] setFill];
    for (int i = 0; i <= count; i ++) {
        CGRect litRect = CGRectMake(i * litRectWidth + litRectWidth / 6, litRectWidth / 3, litRectWidth / 3 * 2, litRectWidth / 3 * 2);
        CGContextFillRect(context, litRect);
        
        CGRect litRect2 = CGRectMake(i * litRectWidth + litRectWidth / 6, litRectWidth + k_Size_little.height, litRectWidth / 3 * 2, litRectWidth / 3 * 2);
        CGContextFillRect(context, litRect2);
    }
    CGContextFillPath(context);
}

#pragma mark - Actions

- (void)addPicture:(UIImage *)aImg
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:aImg];
    imgView.frame = CGRectOffset(imgView.frame, countOfPic * k_Size_little.width, litRectWidth);
    [self addSubview:imgView];
    countOfPic ++;
}


@end
