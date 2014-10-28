//
//  HWActionSheet.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWActionSheet.h"

@implementation HWActionSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        //init
        int btnCount = height / 50 + 1;
        for (int i = 0; i < btnCount; i ++) {
            [self addButtonWithTitle:@""];
        }
    }
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
//    view.backgroundColor = [UIColor redColor];
//    [self addSubview:view];
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%s -> %@", __FUNCTION__, NSStringFromCGRect(self.bounds));
}

@end
