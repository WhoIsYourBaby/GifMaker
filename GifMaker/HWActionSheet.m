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
#import "SettingBundle.h"

@interface HWActionSheet ()

@property (strong, nonatomic) NSArray *countSegArray;

@end

@implementation HWActionSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithHeight:(HWActionSheetHeight)hEnum withSetting:(SettingBundle *)aSB
{
    self = [super init];
    if (self) {
        for (int i = 0; i < hEnum; i ++) {
            [self addButtonWithTitle:@""];
        }
        self.setBundle = aSB;
        self.countSegArray = @[@"16", @"24", @"32"];
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

- (void)initSubViews
{
    int SlctSeg = 0;
    for (int i = 0; i < [self.countSegArray count]; i ++) {
        if ([self.countSegArray[i] intValue] == self.setBundle.countOfImage) {
            SlctSeg = i;
        }
    }
    UISegmentedControl *countSeg = [[UISegmentedControl alloc] initWithItems:self.countSegArray];
    countSeg.frame = CGRectMake(0.3 * self.frame.size.width, 10, 0.6 * self.frame.size.width, 30);
    [countSeg setSelectedSegmentIndex:SlctSeg];
    [countSeg addTarget:self action:@selector(countSegmentChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:countSeg];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.05 * self.frame.size.width, countSeg.frame.origin.y, 0.2 * self.frame.size.width, countSeg.frame.size.height)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.text = NSLocalizedString(@"采像数", nil);
    countLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:countLabel];
    
    UISegmentedControl *methodSeg = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"video"], [UIImage imageNamed:@"camera"]]];
    methodSeg.frame = CGRectMake(0.3 * self.frame.size.width, 50, 0.6 * self.frame.size.width, 36);
    [methodSeg setSelectedSegmentIndex:self.setBundle.methodCate];
    [methodSeg addTarget:self action:@selector(methodSegmentChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:methodSeg];
    
    UILabel *methodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.05 * self.frame.size.width, methodSeg.frame.origin.y, 0.2 * self.frame.size.width, methodSeg.frame.size.height)];
    methodLabel.backgroundColor = [UIColor clearColor];
    methodLabel.text = NSLocalizedString(@"采像方式", nil);
    methodLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [self addSubview:methodLabel];
    
    ASValueTrackingSlider *timeSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0.3 * self.frame.size.width, 110, 0.6 * self.frame.size.width, 5)];
    timeSlider.popUpViewCornerRadius = 2.f;
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    timeSlider.maximumValue = 1.0;
    timeSlider.minimumValue = 0.1;
    [timeSlider setMaxFractionDigitsDisplayed:1];
    [timeSlider setValue:self.setBundle.timeInterval];
    [timeSlider addTarget:self action:@selector(timeSliderChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:timeSlider];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.05 * self.frame.size.width, timeSlider.frame.origin.y - 12, 0.2 * self.frame.size.width, 30)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.text = NSLocalizedString(@"采像间隔", nil);
    timeLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [self addSubview:timeLabel];
}

- (SettingBundle *)setBundle
{
    if (_setBundle == nil) {
        _setBundle = [SettingBundle globalSetting];
    }
    return _setBundle;
}

- (void)countSegmentChange:(UISegmentedControl *)sender
{
    NSInteger sltInd = [sender selectedSegmentIndex];
    self.setBundle.countOfImage = [self.countSegArray[sltInd] intValue];
}

- (void)methodSegmentChange:(UISegmentedControl *)sender
{
    self.setBundle.methodCate = (SettingMethodEnum)[sender selectedSegmentIndex];
}

- (void)timeSliderChange:(UISlider *)sender
{
    self.setBundle.timeInterval = sender.value;
}

- (void)btnDoneTap:(id)sender
{
    [self.setBundle synchronize];
    if (_callback) {
        _callback(self.setBundle);
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}


@end
