//
//  DrawerToolView.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "DrawerToolView.h"

@implementation DrawerToolView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init code
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    self.pagingEnabled = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addButtons:(NSArray *)aArr
{
    if (aArr == nil || [aArr count] == 0) {
        return ;
    }
    UIView *sv = aArr[0];
    int totalWidth = sv.frame.size.width * [aArr count];
    if (self.frame.size.width < totalWidth) {
        self.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
    }
    for (int i = 0; i < [aArr count]; i ++) {
        UIView *vw = aArr[i];
        vw.frame = CGRectOffset(vw.frame, i * vw.frame.size.width, 0);
        [self addSubview:vw];
    }
}

@end
