//
//  HWActionSheet.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWActionSheet.h"
#import <QuartzCore/QuartzCore.h>

@implementation HWActionSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithHeight:(HWActionSheetHeight)hEnum
{
    self = [super init];
    if (self) {
        for (int i = 0; i < hEnum; i ++) {
            [self addButtonWithTitle:@""];
        }
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    for (id subbtn in [self subviews]) {
        if ([subbtn isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            [subbtn removeFromSuperview];
        }
    }
    [self initCustomView];
}

- (void)initCustomView
{
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(50, self.frame.size.height - 52, 220, 36);
    [btnDone setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    btnDone.layer.borderWidth = 1.3;
    btnDone.layer.borderColor = [UIColor blueColor].CGColor;
    [btnDone setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(btnDoneTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDone];
}

- (void)btnDoneTap:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
