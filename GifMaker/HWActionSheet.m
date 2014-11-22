//
//  HWActionSheet.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "ASValueTrackingSlider.h"

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
    btnDone.frame = CGRectMake(0.2 * self.frame.size.width, self.frame.size.height - 45, 0.6 * self.frame.size.width, 30);
    [btnDone setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    btnDone.layer.borderWidth = 1.0;
    btnDone.layer.borderColor = [UIColor colorWithRed:44/255.f green:93/255.f blue:205/255.f alpha:1.0].CGColor;
    [btnDone setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(btnDoneTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDone];
    
    [self initSubViews];
}

- (void)btnDoneTap:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)initSubViews
{
    UISegmentedControl *countSeg = [[UISegmentedControl alloc] initWithItems:@[@"16", @"24", @"32"]];
    countSeg.frame = CGRectMake(0.15 * self.frame.size.width, 10, 0.7 * self.frame.size.width, 30);
    [countSeg setSelectedSegmentIndex:0];
    [countSeg addTarget:self action:@selector(countSegmentChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:countSeg];
    
    UISegmentedControl *methodSeg = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"camera"], [UIImage imageNamed:@"video"]]];
    methodSeg.frame = CGRectMake(0.15 * self.frame.size.width, 50, 0.7 * self.frame.size.width, 36);
    [methodSeg setSelectedSegmentIndex:0];
    [methodSeg addTarget:self action:@selector(methodSegmentChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:methodSeg];
    
    ASValueTrackingSlider *timeSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0.15 * self.frame.size.width, 110, 0.7 * self.frame.size.width, 5)];
    timeSlider.popUpViewCornerRadius = 2.f;
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    timeSlider.maximumValue = 16;
    timeSlider.minimumValue = 1.6;
    [timeSlider setMaxFractionDigitsDisplayed:1];
    [self addSubview:timeSlider];
}


- (void)countSegmentChange:(id)sender
{
    NSLog(@"%s", __func__);
}

- (void)methodSegmentChange:(id)sender
{
    NSLog(@"%s", __func__);
}

@end
